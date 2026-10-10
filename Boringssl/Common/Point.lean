module

public import Firedancer.Common.Point
import Std.Data.ExtHashMap.Lemmas
import MLIR.Run.Tactic.Memory
import Mathlib.Tactic.FinCases

/-! ref10's points in memory: `ge_p2`, `ge_p3`, `ge_p1p1`, `ge_precomp` and `ge_cached`, their field
elements at byte offsets 0, 40, 80 (and 120), read and stored as a whole. A point of four field
elements fits as `PointFit`, one of three as `Fe3Fit`. -/

namespace MLIR

open Memory

@[expose] public section

/-! ### Objects -/

/-- `ge_p2`: projective `(X : Y : Z)`. -/
structure GeP2 where
  X : Fin 5 → BitVec 64
  Y : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64

/-- `ge_p3`: extended `(X : Y : Z : T)`. -/
structure GeP3 where
  X : Fin 5 → BitVec 64
  Y : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64
  T : Fin 5 → BitVec 64

/-- `ge_p1p1`: completed `((X : Z), (Y : T))`. -/
structure GeP1p1 where
  X : Fin 5 → BitVec 64
  Y : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64
  T : Fin 5 → BitVec 64

/-- `ge_precomp`: `(y + x, y - x, 2d x y)`. -/
structure GePrecomp where
  yplusx : Fin 5 → BitVec 64
  yminusx : Fin 5 → BitVec 64
  xy2d : Fin 5 → BitVec 64

/-- `ge_cached`: `(Y + X, Y - X, Z, 2d T)`. -/
structure GeCached where
  YplusX : Fin 5 → BitVec 64
  YminusX : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64
  T2d : Fin 5 → BitVec 64

/-- The `ge_p2` at `p`. -/
def MemoryState.readP2 (m : MemoryState) (p : Pointer) : GeP2 :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64)⟩

/-- The `ge_p3` at `p`. -/
def MemoryState.readP3 (m : MemoryState) (p : Pointer) : GeP3 :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- The `ge_p1p1` at `p`. -/
def MemoryState.readP1p1 (m : MemoryState) (p : Pointer) : GeP1p1 :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- The `ge_precomp` at `p`. -/
def MemoryState.readPrecomp (m : MemoryState) (p : Pointer) : GePrecomp :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64)⟩

/-- The `ge_cached` at `p`. -/
def MemoryState.readCached (m : MemoryState) (p : Pointer) : GeCached :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- Store the `ge_p2` `P` at `p`, field by field. -/
def MemoryState.storeP2 (m : MemoryState) (p : Pointer) (P : GeP2) : MemoryState :=
  ((m.storeLimbs p P.X).storeLimbs (p.add 40#64) P.Y).storeLimbs (p.add 80#64) P.Z

/-- Store the `ge_p3` `P` at `p`, field by field. -/
def MemoryState.storeP3 (m : MemoryState) (p : Pointer) (P : GeP3) : MemoryState :=
  (((m.storeLimbs p P.X).storeLimbs (p.add 40#64) P.Y).storeLimbs (p.add 80#64) P.Z).storeLimbs
    (p.add 120#64) P.T

/-- Store the `ge_p1p1` `P` at `p`, field by field. -/
def MemoryState.storeP1p1 (m : MemoryState) (p : Pointer) (P : GeP1p1) : MemoryState :=
  (((m.storeLimbs p P.X).storeLimbs (p.add 40#64) P.Y).storeLimbs (p.add 80#64) P.Z).storeLimbs
    (p.add 120#64) P.T

/-- Store the `ge_cached` `P` at `p`, field by field. -/
def MemoryState.storeCached (m : MemoryState) (p : Pointer) (P : GeCached) : MemoryState :=
  (((m.storeLimbs p P.YplusX).storeLimbs (p.add 40#64) P.YminusX).storeLimbs (p.add 80#64)
        P.Z).storeLimbs
    (p.add 120#64) P.T2d

/-- The three field elements at `p` fit (`ge_p2`, `ge_precomp`): offsets do not wrap, each fits. -/
abbrev MemoryState.Fe3Fit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 120 ≤ 2 ^ 64 ∧ m.LimbsFit p ∧ m.LimbsFit (p.add 40#64) ∧ m.LimbsFit (p.add 80#64)

/-- Room for the three field elements at `p`: offsets do not wrap, room for each. -/
abbrev MemoryState.Fe3Room (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 120 ≤ 2 ^ 64 ∧
    m.LimbsRoom p ∧ m.LimbsRoom (p.add 40#64) ∧ m.LimbsRoom (p.add 80#64)

theorem MemoryState.Fe3Fit.room {m : MemoryState} (h : m.Fe3Fit p) : m.Fe3Room p :=
  ⟨h.1, h.2.1.room, h.2.2.1.room, h.2.2.2.room⟩

@[mlir_transport]
theorem MemoryState.Fe3Fit.limbsFit_0 {m : MemoryState} (h : m.Fe3Fit p) : m.LimbsFit p :=
  h.2.1

@[mlir_transport]
theorem MemoryState.Fe3Fit.limbsFit_40 {m : MemoryState} (h : m.Fe3Fit p) :
    m.LimbsFit (p.add 40#64) :=
  h.2.2.1

@[mlir_transport]
theorem MemoryState.Fe3Fit.limbsFit_80 {m : MemoryState} (h : m.Fe3Fit p) :
    m.LimbsFit (p.add 80#64) :=
  h.2.2.2

@[mlir_transport]
theorem MemoryState.Fe3Room.limbsRoom_0 {m : MemoryState} (h : m.Fe3Room p) : m.LimbsRoom p :=
  h.2.1

@[mlir_transport]
theorem MemoryState.Fe3Room.limbsRoom_40 {m : MemoryState} (h : m.Fe3Room p) :
    m.LimbsRoom (p.add 40#64) :=
  h.2.2.1

@[mlir_transport]
theorem MemoryState.Fe3Room.limbsRoom_80 {m : MemoryState} (h : m.Fe3Room p) :
    m.LimbsRoom (p.add 80#64) :=
  h.2.2.2

/-! ### Field elements of one object -/

/-- Two field elements at byte offsets `a` and `b`, at least 40 apart, of an object of `n` bytes.
-/
theorem Range.disjoint_fe {p : Pointer} {n a b : Nat} (hp : p.offset.toNat + n ≤ 2 ^ 64)
    (ha : a + 40 ≤ n) (hb : b + 40 ≤ n) (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (Range.of (p.add (BitVec.ofNat 64 a)) 320).Disjoint
      (Range.of (p.add (BitVec.ofNat 64 b)) 320) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega : b < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

theorem Pointer.fe_offset {p : Pointer} {n a : Nat} (hp : p.offset.toNat + n ≤ 2 ^ 64)
    (ha : a + 40 ≤ n) : (p.add (BitVec.ofNat 64 a)).offset.toNat + 32 < 2 ^ 64 := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A field element of an object read past a store to another of its field elements. -/
theorem MemoryState.readLimbs_storeLimbs_fe {m : MemoryState} {p : Pointer} {n a b : Nat}
    (hp : p.offset.toNat + n ≤ 2 ^ 64) (ha : a + 40 ≤ n) (hb : b + 40 ≤ n)
    (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) :=
  readLimbs_storeLimbs_of_disjoint (Range.disjoint_fe hp ha hb hab) (Pointer.fe_offset hp ha)
    (Pointer.fe_offset hp hb)

/-- `readLimbs_storeLimbs_fe` for a store to the first field element. -/
theorem MemoryState.readLimbs_storeLimbs_fe_X {m : MemoryState} {p : Pointer} {n b : Nat}
    (hp : p.offset.toNat + n ≤ 2 ^ 64) (hb : b + 40 ≤ n) (h40 : 40 ≤ b) :
    (m.storeLimbs p l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) := by
  have h := readLimbs_storeLimbs_fe (m := m) (l := l) (a := 0) hp (by omega) hb (by omega)
  rwa [Pointer.add_zero'] at h

/-- `readLimbs_storeLimbs_fe` for a read of the first field element. -/
theorem MemoryState.readLimbs_storeLimbs_fe_of_X {m : MemoryState} {p : Pointer} {n a : Nat}
    (hp : p.offset.toNat + n ≤ 2 ^ 64) (ha : a + 40 ≤ n) (h40 : 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs p = m.readLimbs p := by
  have h := readLimbs_storeLimbs_fe (m := m) (l := l) (b := 0) hp ha (by omega) (by omega)
  rwa [Pointer.add_zero'] at h

/-- A field element of a three-element object read past a store to another. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_coord3 {m : MemoryState} {p : Pointer} {a b : Nat}
    (h : m.Fe3Room p) (ha : a ≤ 80) (hb : b ≤ 80) (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) :=
  readLimbs_storeLimbs_fe h.1 (by omega) (by omega) hab

/-- `readLimbs_storeLimbs_coord3` for a store to the first field element. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_coord3_X {m : MemoryState} {p : Pointer} {b : Nat}
    (h : m.Fe3Room p) (hb : b ≤ 80) (h40 : 40 ≤ b) :
    (m.storeLimbs p l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) :=
  readLimbs_storeLimbs_fe_X h.1 (by omega) h40

/-- `readLimbs_storeLimbs_coord3` for a read of the first field element. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_coord3_of_X {m : MemoryState} {p : Pointer} {a : Nat}
    (h : m.Fe3Room p) (ha : a ≤ 80) (h40 : 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs p = m.readLimbs p :=
  readLimbs_storeLimbs_fe_of_X h.1 (by omega) h40

/-- Stores to two field elements of an object of `n` bytes commute. -/
theorem MemoryState.storeLimbs_comm_fe {m : MemoryState} {p : Pointer} {n a b : Nat}
    (hp : p.offset.toNat + n ≤ 2 ^ 64) (ha : a + 40 ≤ n) (hb : b + 40 ≤ n)
    (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) A).storeLimbs (p.add (BitVec.ofNat 64 b)) B =
      (m.storeLimbs (p.add (BitVec.ofNat 64 b)) B).storeLimbs (p.add (BitVec.ofNat 64 a)) A :=
  storeLimbs_comm (Pointer.fe_offset hp ha) (Pointer.fe_offset hp hb)
    (Range.disjoint_fe hp ha hb hab)

/-- `storeLimbs_comm_fe` for the first field element, stored second. -/
theorem MemoryState.storeLimbs_comm_fe_X {m : MemoryState} {p : Pointer} {n a : Nat}
    (hp : p.offset.toNat + n ≤ 2 ^ 64) (ha : a + 40 ≤ n) (h40 : 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) A).storeLimbs p B =
      (m.storeLimbs p B).storeLimbs (p.add (BitVec.ofNat 64 a)) A := by
  have h := storeLimbs_comm_fe (m := m) (A := A) (B := B) (b := 0) hp ha (by omega) (by omega)
  rwa [Pointer.add_zero'] at h

/-- A field element outside the block of a store: the limbs before it. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  have h8 := h' 8#64
  have h16 := h' 16#64
  have h24 := h' 24#64
  have h32 := h' 32#64
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs, Tactic.readThroughStore]

/-! ### Three-element objects across writes, `alloca`s and frames -/

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.storeAt {m : MemoryState} {x : BitVec w} (h : m.Fe3Fit q) :
    (m.storeAt p x).Fe3Fit q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.storeAt {m : MemoryState} {x : BitVec w} (h : m.Fe3Room q) :
    (m.storeAt p x).Fe3Room q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.storeLimbs {m : MemoryState} (h : m.Fe3Fit q) :
    (m.storeLimbs p l).Fe3Fit q :=
  ⟨h.1, h.2.1.storeLimbs, h.2.2.1.storeLimbs, h.2.2.2.storeLimbs⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.storeLimbs {m : MemoryState} (h : m.Fe3Room q) :
    (m.storeLimbs p l).Fe3Room q :=
  ⟨h.1, h.2.1.storeLimbs, h.2.2.1.storeLimbs, h.2.2.2.storeLimbs⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.alloca {s : GlobalState} (hne : q.id ≠ s.allocaPtr.id)
    (h : s.mem.Fe3Fit q) : (s.alloca n d).mem.Fe3Fit q := by
  have hne' (k : BitVec 64) : (q.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.alloca hne, h.2.2.1.alloca (hne' _), h.2.2.2.alloca (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.alloca {s : GlobalState} (hne : q.id ≠ s.allocaPtr.id)
    (h : s.mem.Fe3Room q) : (s.alloca n d).mem.Fe3Room q := by
  have hne' (k : BitVec 64) : (q.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.alloca hne, h.2.2.1.alloca (hne' _), h.2.2.2.alloca (hne' _)⟩

@[mlir_transport]
theorem MemoryState.Fe3Fit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.Fe3Fit q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).Fe3Fit q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.addBlock hwf⟩

@[mlir_transport]
theorem MemoryState.Fe3Room.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.Fe3Room q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).Fe3Room q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.Fe3Fit p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).Fe3Fit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.Fe3Fit p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).Fe3Fit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.lifetimeEnd (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.Fe3Room p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).Fe3Room p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.Fe3Room p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).Fe3Room p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.lifetimeEnd (hne' _)⟩

/-- A 120-byte block from its start holds three field elements. -/
theorem MemoryState.Fe3Fit.of_fits {m : MemoryState} (h : Fits m p 960) (ho : p.offset = 0) :
    m.Fe3Fit p := by
  have hk (k : BitVec 64) (hk : k.toNat ≤ 80) : m.LimbsFit (p.add k) := by
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
  exact ⟨by simp [ho], .of_fits (h.mono (by omega)) ho, hk _ (by decide), hk _ (by decide)⟩

/-- A 120-byte live block from its start has room for three field elements. -/
theorem MemoryState.Fe3Room.of_room {m : MemoryState} (h : Room m p 960) (ho : p.offset = 0) :
    m.Fe3Room p := by
  have hk (k : BitVec 64) (hk : k.toNat ≤ 80) : m.LimbsRoom (p.add k) := by
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
  exact ⟨by simp [ho], .of_room (h.mono (by omega)) ho, hk _ (by decide), hk _ (by decide)⟩

/-! ### `readP2` past other writes -/

@[mlir_read]
theorem MemoryState.readP2_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeLimbs p l).readP2 q = m.readP2 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP2, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP2_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readP2 q = m.readP2 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  have h0 := h' 0
  have h8 := h' 8#64
  simp only [MemoryState.readP2]
  congr 1 <;> funext i <;> fin_cases i <;>
    simp only [MemoryState.readLimbs, Pointer.add_add, Tactic.readThroughStore]

@[mlir_frame, mlir_read]
theorem MemoryState.readP2_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readP2 p = s.mem.readP2 p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readP2, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readP2_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readP2 p = m.readP2 p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP2, readLimbs_addBlock_of_id_ne h, readLimbs_addBlock_of_id_ne (h' _)]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readP2_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readP2 p = m.readP2 p := by
  simp only [MemoryState.readP2, readLimbs_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readP2_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readP2 p = m.readP2 p := by
  simp only [MemoryState.readP2, readLimbs_lifetimeEnd]

/-! ### `readP3` past other writes -/

@[mlir_read]
theorem MemoryState.readP3_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeLimbs p l).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP3, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP3_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  have h0 := h' 0
  have h8 := h' 8#64
  simp only [MemoryState.readP3]
  congr 1 <;> funext i <;> fin_cases i <;>
    simp only [MemoryState.readLimbs, Pointer.add_add, Tactic.readThroughStore]

@[mlir_frame, mlir_read]
theorem MemoryState.readP3_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readP3 p = s.mem.readP3 p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readP3, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readP3_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readP3 p = m.readP3 p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP3, readLimbs_addBlock_of_id_ne h, readLimbs_addBlock_of_id_ne (h' _)]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readP3_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readP3 p = m.readP3 p := by
  simp only [MemoryState.readP3, readLimbs_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readP3_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readP3 p = m.readP3 p := by
  simp only [MemoryState.readP3, readLimbs_lifetimeEnd]

/-! ### `readP1p1` past other writes -/

@[mlir_read]
theorem MemoryState.readP1p1_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeLimbs p l).readP1p1 q = m.readP1p1 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP1p1, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP1p1_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readP1p1 q = m.readP1p1 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  have h0 := h' 0
  have h8 := h' 8#64
  simp only [MemoryState.readP1p1]
  congr 1 <;> funext i <;> fin_cases i <;>
    simp only [MemoryState.readLimbs, Pointer.add_add, Tactic.readThroughStore]

@[mlir_frame, mlir_read]
theorem MemoryState.readP1p1_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readP1p1 p = s.mem.readP1p1 p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readP1p1, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readP1p1_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readP1p1 p = m.readP1p1 p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP1p1, readLimbs_addBlock_of_id_ne h,
    readLimbs_addBlock_of_id_ne (h' _)]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readP1p1_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readP1p1 p = m.readP1p1 p := by
  simp only [MemoryState.readP1p1, readLimbs_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readP1p1_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readP1p1 p = m.readP1p1 p := by
  simp only [MemoryState.readP1p1, readLimbs_lifetimeEnd]

/-! ### `readPrecomp` past other writes -/

@[mlir_read]
theorem MemoryState.readPrecomp_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeLimbs p l).readPrecomp q = m.readPrecomp q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPrecomp, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readPrecomp_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readPrecomp q = m.readPrecomp q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  have h0 := h' 0
  have h8 := h' 8#64
  simp only [MemoryState.readPrecomp]
  congr 1 <;> funext i <;> fin_cases i <;>
    simp only [MemoryState.readLimbs, Pointer.add_add, Tactic.readThroughStore]

@[mlir_frame, mlir_read]
theorem MemoryState.readPrecomp_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readPrecomp p = s.mem.readPrecomp p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readPrecomp, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readPrecomp_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readPrecomp p = m.readPrecomp p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPrecomp, readLimbs_addBlock_of_id_ne h,
    readLimbs_addBlock_of_id_ne (h' _)]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readPrecomp_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readPrecomp p = m.readPrecomp p := by
  simp only [MemoryState.readPrecomp, readLimbs_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readPrecomp_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readPrecomp p = m.readPrecomp p := by
  simp only [MemoryState.readPrecomp, readLimbs_lifetimeEnd]

/-! ### `readCached` past other writes -/

@[mlir_read]
theorem MemoryState.readCached_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeLimbs p l).readCached q = m.readCached q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCached, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCached_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readCached q = m.readCached q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  have h0 := h' 0
  have h8 := h' 8#64
  simp only [MemoryState.readCached]
  congr 1 <;> funext i <;> fin_cases i <;>
    simp only [MemoryState.readLimbs, Pointer.add_add, Tactic.readThroughStore]

@[mlir_frame, mlir_read]
theorem MemoryState.readCached_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readCached p = s.mem.readCached p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readCached, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readCached_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readCached p = m.readCached p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCached, readLimbs_addBlock_of_id_ne h,
    readLimbs_addBlock_of_id_ne (h' _)]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readCached_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readCached p = m.readCached p := by
  simp only [MemoryState.readCached, readLimbs_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readCached_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readCached p = m.readCached p := by
  simp only [MemoryState.readCached, readLimbs_lifetimeEnd]

/-! ### `storeP2` -/

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storeP2_iff {m : MemoryState} :
    (m.storeP2 p P).LimbsRoom q ↔ m.LimbsRoom q := by simp [MemoryState.storeP2]

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeP2 {m : MemoryState} (h : m.LimbsFit q) :
    (m.storeP2 p P).LimbsFit q :=
  h.storeLimbs.storeLimbs.storeLimbs

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeP2 {m : MemoryState} (h : m.LimbsRoom q) :
    (m.storeP2 p P).LimbsRoom q :=
  limbsRoom_storeP2_iff.mpr h

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeP2 {m : MemoryState} (h : m.PointFit q) :
    (m.storeP2 p P).PointFit q :=
  ⟨h.1, h.2.1.storeP2, h.2.2.1.storeP2, h.2.2.2.1.storeP2, h.2.2.2.2.storeP2⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeP2 {m : MemoryState} (h : m.PointRoom q) :
    (m.storeP2 p P).PointRoom q :=
  ⟨h.1, h.2.1.storeP2, h.2.2.1.storeP2, h.2.2.2.1.storeP2, h.2.2.2.2.storeP2⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.storeP2 {m : MemoryState} (h : m.Fe3Fit q) : (m.storeP2 p P).Fe3Fit q :=
  ⟨h.1, h.2.1.storeP2, h.2.2.1.storeP2, h.2.2.2.storeP2⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.storeP2 {m : MemoryState} (h : m.Fe3Room q) :
    (m.storeP2 p P).Fe3Room q :=
  ⟨h.1, h.2.1.storeP2, h.2.2.1.storeP2, h.2.2.2.storeP2⟩

@[mlir_transport]
theorem Fits.storeP2 {m : MemoryState} (h : Fits m q w) : Fits (m.storeP2 p P) q w := by
  simp only [MemoryState.storeP2]
  exact h.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
theorem InBounds.storeP2 {m : MemoryState} (h : InBounds m q w) : InBounds (m.storeP2 p P) q w := by
  simp only [MemoryState.storeP2]
  exact h.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
theorem Room.storeP2 {m : MemoryState} (h : Room m q w) : Room (m.storeP2 p P) q w := by
  simp only [MemoryState.storeP2]
  exact h.storeLimbs.storeLimbs.storeLimbs

@[simp, mlir_mem]
theorem GlobalState.WF_storeP2 {s : GlobalState} :
    ({ s with mem := m.storeP2 p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeP2]

@[mlir_transport]
theorem GlobalState.WF.storeP2 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeP2 p P } : GlobalState).WF :=
  GlobalState.WF_storeP2.mpr h

/-- `WF.storeP2` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeP2_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeP2 p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeP2 (s := ⟨a, m⟩) h

@[mlir_read]
theorem MemoryState.readLimbs_storeP2_X {m : MemoryState} {p : Pointer} (h : m.Fe3Room p) :
    (m.storeP2 p P).readLimbs p = P.X := by
  simp only [MemoryState.storeP2]
  rw [readLimbs_storeLimbs_fe_of_X (a := 80) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_fe_of_X (a := 40) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.1]

@[mlir_read]
theorem MemoryState.readLimbs_storeP2_Y {m : MemoryState} {p : Pointer} (h : m.Fe3Room p) :
    (m.storeP2 p P).readLimbs (p.add 40#64) = P.Y := by
  simp only [MemoryState.storeP2]
  rw [readLimbs_storeLimbs_fe (a := 80) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.1.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storeP2_Z {m : MemoryState} {p : Pointer} (h : m.Fe3Room p) :
    (m.storeP2 p P).readLimbs (p.add 80#64) = P.Z := by
  simp only [MemoryState.storeP2]
  rw [readLimbs_storeLimbs_self h.2.2.2.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readP2_storeP2_self {m : MemoryState} {p : Pointer} (h : m.Fe3Room p) :
    (m.storeP2 p P).readP2 p = P := by
  simp only [MemoryState.readP2, readLimbs_storeP2_X h, readLimbs_storeP2_Y h,
    readLimbs_storeP2_Z h]

/-- A `ge_p2` stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.Fe3Fit.storeP2_self {m : MemoryState} {p : Pointer} (h : m.Fe3Room p) :
    (m.storeP2 p P).Fe3Fit p := by
  unfold MemoryState.storeP2
  exact
    ⟨h.1, (MemoryState.LimbsFit.storeLimbs_self h.2.1).storeLimbs.storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.1.storeLimbs).storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.2.storeLimbs.storeLimbs)⟩

@[mlir_read]
theorem MemoryState.readLimbs_storeP2_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP2 p P).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeP2, readLimbs_storeLimbs_of_id_ne (h' _),
    readLimbs_storeLimbs_of_id_ne h]

@[mlir_read]
theorem MemoryState.readAt_storeP2_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP2 p P).readAt q w = m.readAt q w := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  have h40 := h' 40#64
  have h80 := h' 80#64
  simp only [MemoryState.storeP2, MemoryState.storeLimbs, Tactic.readThroughStore]

@[mlir_read]
theorem MemoryState.readP3_storeP2_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP2 p P).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP3, readLimbs_storeP2_of_id_ne h, readLimbs_storeP2_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP1p1_storeP2_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP2 p P).readP1p1 q = m.readP1p1 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP1p1, readLimbs_storeP2_of_id_ne h, readLimbs_storeP2_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readPrecomp_storeP2_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeP2 p P).readPrecomp q = m.readPrecomp q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPrecomp, readLimbs_storeP2_of_id_ne h,
    readLimbs_storeP2_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCached_storeP2_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeP2 p P).readCached q = m.readCached q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCached, readLimbs_storeP2_of_id_ne h,
    readLimbs_storeP2_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP2_storeP2_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP2 p P).readP2 q = m.readP2 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP2, readLimbs_storeP2_of_id_ne h, readLimbs_storeP2_of_id_ne (h' _)]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeP2 {m : MemoryState} :
    (m.storeP2 p P).eraseFrom n = (m.eraseFrom n).storeP2 p P := by
  simp [MemoryState.storeP2, MemoryState.eraseFrom_storeLimbs]

@[mlir_frame, mlir_erase]
theorem MemoryState.storeP2_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeP2 p P = m.eraseFrom n := by
  simp [MemoryState.storeP2, MemoryState.storeLimbs_eraseFrom_of_le, Pointer.add, h]

/-- A `ge_p2` store into a block the erase removes: dropped before the erase moves inward. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeP2_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeP2 p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeP2, storeP2_eraseFrom_of_le h]

/-! ### `storeP3` -/

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storeP3_iff {m : MemoryState} :
    (m.storeP3 p P).LimbsRoom q ↔ m.LimbsRoom q := by simp [MemoryState.storeP3]

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeP3 {m : MemoryState} (h : m.LimbsFit q) :
    (m.storeP3 p P).LimbsFit q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeP3 {m : MemoryState} (h : m.LimbsRoom q) :
    (m.storeP3 p P).LimbsRoom q :=
  limbsRoom_storeP3_iff.mpr h

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeP3 {m : MemoryState} (h : m.PointFit q) :
    (m.storeP3 p P).PointFit q :=
  ⟨h.1, h.2.1.storeP3, h.2.2.1.storeP3, h.2.2.2.1.storeP3, h.2.2.2.2.storeP3⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeP3 {m : MemoryState} (h : m.PointRoom q) :
    (m.storeP3 p P).PointRoom q :=
  ⟨h.1, h.2.1.storeP3, h.2.2.1.storeP3, h.2.2.2.1.storeP3, h.2.2.2.2.storeP3⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.storeP3 {m : MemoryState} (h : m.Fe3Fit q) : (m.storeP3 p P).Fe3Fit q :=
  ⟨h.1, h.2.1.storeP3, h.2.2.1.storeP3, h.2.2.2.storeP3⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.storeP3 {m : MemoryState} (h : m.Fe3Room q) :
    (m.storeP3 p P).Fe3Room q :=
  ⟨h.1, h.2.1.storeP3, h.2.2.1.storeP3, h.2.2.2.storeP3⟩

@[mlir_transport]
theorem Fits.storeP3 {m : MemoryState} (h : Fits m q w) : Fits (m.storeP3 p P) q w := by
  simp only [MemoryState.storeP3]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
theorem InBounds.storeP3 {m : MemoryState} (h : InBounds m q w) : InBounds (m.storeP3 p P) q w := by
  simp only [MemoryState.storeP3]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
theorem Room.storeP3 {m : MemoryState} (h : Room m q w) : Room (m.storeP3 p P) q w := by
  simp only [MemoryState.storeP3]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[simp, mlir_mem]
theorem GlobalState.WF_storeP3 {s : GlobalState} :
    ({ s with mem := m.storeP3 p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeP3]

@[mlir_transport]
theorem GlobalState.WF.storeP3 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeP3 p P } : GlobalState).WF :=
  GlobalState.WF_storeP3.mpr h

/-- `WF.storeP3` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeP3_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeP3 p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeP3 (s := ⟨a, m⟩) h

@[mlir_read]
theorem MemoryState.readLimbs_storeP3_X {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP3 p P).readLimbs p = P.X := by
  simp only [MemoryState.storeP3]
  rw [readLimbs_storeLimbs_fe_of_X (a := 120) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_fe_of_X (a := 80) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_fe_of_X (a := 40) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.1]

@[mlir_read]
theorem MemoryState.readLimbs_storeP3_Y {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP3 p P).readLimbs (p.add 40#64) = P.Y := by
  simp only [MemoryState.storeP3]
  rw [readLimbs_storeLimbs_fe (a := 120) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_fe (a := 80) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.1.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storeP3_Z {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP3 p P).readLimbs (p.add 80#64) = P.Z := by
  simp only [MemoryState.storeP3]
  rw [readLimbs_storeLimbs_fe (a := 120) (b := 80) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storeP3_T {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP3 p P).readLimbs (p.add 120#64) = P.T := by
  simp only [MemoryState.storeP3]
  rw [readLimbs_storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readP3_storeP3_self {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP3 p P).readP3 p = P := by
  simp only [MemoryState.readP3, readLimbs_storeP3_X h, readLimbs_storeP3_Y h,
    readLimbs_storeP3_Z h, readLimbs_storeP3_T h]

/-- A `ge_p3` stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.PointFit.storeP3_self {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP3 p P).PointFit p := by
  unfold MemoryState.storeP3
  exact
    ⟨h.1, (MemoryState.LimbsFit.storeLimbs_self h.2.1).storeLimbs.storeLimbs.storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.1.storeLimbs).storeLimbs.storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs).storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs.storeLimbs)⟩

@[mlir_read]
theorem MemoryState.readLimbs_storeP3_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP3 p P).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeP3, readLimbs_storeLimbs_of_id_ne (h' _),
    readLimbs_storeLimbs_of_id_ne h]

@[mlir_read]
theorem MemoryState.readAt_storeP3_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP3 p P).readAt q w = m.readAt q w := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  have h40 := h' 40#64
  have h80 := h' 80#64
  have h120 := h' 120#64
  simp only [MemoryState.storeP3, MemoryState.storeLimbs, Tactic.readThroughStore]

@[mlir_read]
theorem MemoryState.readP2_storeP3_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP3 p P).readP2 q = m.readP2 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP2, readLimbs_storeP3_of_id_ne h, readLimbs_storeP3_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP1p1_storeP3_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP3 p P).readP1p1 q = m.readP1p1 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP1p1, readLimbs_storeP3_of_id_ne h, readLimbs_storeP3_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readPrecomp_storeP3_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeP3 p P).readPrecomp q = m.readPrecomp q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPrecomp, readLimbs_storeP3_of_id_ne h,
    readLimbs_storeP3_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCached_storeP3_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeP3 p P).readCached q = m.readCached q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCached, readLimbs_storeP3_of_id_ne h,
    readLimbs_storeP3_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP3_storeP3_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP3 p P).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP3, readLimbs_storeP3_of_id_ne h, readLimbs_storeP3_of_id_ne (h' _)]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeP3 {m : MemoryState} :
    (m.storeP3 p P).eraseFrom n = (m.eraseFrom n).storeP3 p P := by
  simp [MemoryState.storeP3, MemoryState.eraseFrom_storeLimbs]

@[mlir_frame, mlir_erase]
theorem MemoryState.storeP3_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeP3 p P = m.eraseFrom n := by
  simp [MemoryState.storeP3, MemoryState.storeLimbs_eraseFrom_of_le, Pointer.add, h]

/-- A `ge_p3` store into a block the erase removes: dropped before the erase moves inward. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeP3_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeP3 p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeP3, storeP3_eraseFrom_of_le h]

/-! ### `storeP1p1` -/

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storeP1p1_iff {m : MemoryState} :
    (m.storeP1p1 p P).LimbsRoom q ↔ m.LimbsRoom q := by simp [MemoryState.storeP1p1]

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeP1p1 {m : MemoryState} (h : m.LimbsFit q) :
    (m.storeP1p1 p P).LimbsFit q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeP1p1 {m : MemoryState} (h : m.LimbsRoom q) :
    (m.storeP1p1 p P).LimbsRoom q :=
  limbsRoom_storeP1p1_iff.mpr h

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeP1p1 {m : MemoryState} (h : m.PointFit q) :
    (m.storeP1p1 p P).PointFit q :=
  ⟨h.1, h.2.1.storeP1p1, h.2.2.1.storeP1p1, h.2.2.2.1.storeP1p1, h.2.2.2.2.storeP1p1⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeP1p1 {m : MemoryState} (h : m.PointRoom q) :
    (m.storeP1p1 p P).PointRoom q :=
  ⟨h.1, h.2.1.storeP1p1, h.2.2.1.storeP1p1, h.2.2.2.1.storeP1p1, h.2.2.2.2.storeP1p1⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.storeP1p1 {m : MemoryState} (h : m.Fe3Fit q) :
    (m.storeP1p1 p P).Fe3Fit q :=
  ⟨h.1, h.2.1.storeP1p1, h.2.2.1.storeP1p1, h.2.2.2.storeP1p1⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.storeP1p1 {m : MemoryState} (h : m.Fe3Room q) :
    (m.storeP1p1 p P).Fe3Room q :=
  ⟨h.1, h.2.1.storeP1p1, h.2.2.1.storeP1p1, h.2.2.2.storeP1p1⟩

@[mlir_transport]
theorem Fits.storeP1p1 {m : MemoryState} (h : Fits m q w) : Fits (m.storeP1p1 p P) q w := by
  simp only [MemoryState.storeP1p1]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
theorem InBounds.storeP1p1 {m : MemoryState} (h : InBounds m q w) :
    InBounds (m.storeP1p1 p P) q w := by
  simp only [MemoryState.storeP1p1]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
theorem Room.storeP1p1 {m : MemoryState} (h : Room m q w) : Room (m.storeP1p1 p P) q w := by
  simp only [MemoryState.storeP1p1]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[simp, mlir_mem]
theorem GlobalState.WF_storeP1p1 {s : GlobalState} :
    ({ s with mem := m.storeP1p1 p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeP1p1]

@[mlir_transport]
theorem GlobalState.WF.storeP1p1 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeP1p1 p P } : GlobalState).WF :=
  GlobalState.WF_storeP1p1.mpr h

/-- `WF.storeP1p1` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeP1p1_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeP1p1 p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeP1p1 (s := ⟨a, m⟩) h

@[mlir_read]
theorem MemoryState.readLimbs_storeP1p1_X {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP1p1 p P).readLimbs p = P.X := by
  simp only [MemoryState.storeP1p1]
  rw [readLimbs_storeLimbs_fe_of_X (a := 120) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_fe_of_X (a := 80) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_fe_of_X (a := 40) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.1]

@[mlir_read]
theorem MemoryState.readLimbs_storeP1p1_Y {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP1p1 p P).readLimbs (p.add 40#64) = P.Y := by
  simp only [MemoryState.storeP1p1]
  rw [readLimbs_storeLimbs_fe (a := 120) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_fe (a := 80) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.1.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storeP1p1_Z {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP1p1 p P).readLimbs (p.add 80#64) = P.Z := by
  simp only [MemoryState.storeP1p1]
  rw [readLimbs_storeLimbs_fe (a := 120) (b := 80) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storeP1p1_T {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP1p1 p P).readLimbs (p.add 120#64) = P.T := by
  simp only [MemoryState.storeP1p1]
  rw [readLimbs_storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readP1p1_storeP1p1_self {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP1p1 p P).readP1p1 p = P := by
  simp only [MemoryState.readP1p1, readLimbs_storeP1p1_X h, readLimbs_storeP1p1_Y h,
    readLimbs_storeP1p1_Z h, readLimbs_storeP1p1_T h]

/-- A `ge_p1p1` stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.PointFit.storeP1p1_self {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeP1p1 p P).PointFit p := by
  unfold MemoryState.storeP1p1
  exact
    ⟨h.1, (MemoryState.LimbsFit.storeLimbs_self h.2.1).storeLimbs.storeLimbs.storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.1.storeLimbs).storeLimbs.storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs).storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs.storeLimbs)⟩

@[mlir_read]
theorem MemoryState.readLimbs_storeP1p1_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeP1p1 p P).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeP1p1, readLimbs_storeLimbs_of_id_ne (h' _),
    readLimbs_storeLimbs_of_id_ne h]

@[mlir_read]
theorem MemoryState.readAt_storeP1p1_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP1p1 p P).readAt q w = m.readAt q w := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  have h40 := h' 40#64
  have h80 := h' 80#64
  have h120 := h' 120#64
  simp only [MemoryState.storeP1p1, MemoryState.storeLimbs, Tactic.readThroughStore]

@[mlir_read]
theorem MemoryState.readP2_storeP1p1_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP1p1 p P).readP2 q = m.readP2 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP2, readLimbs_storeP1p1_of_id_ne h,
    readLimbs_storeP1p1_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP3_storeP1p1_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeP1p1 p P).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP3, readLimbs_storeP1p1_of_id_ne h,
    readLimbs_storeP1p1_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readPrecomp_storeP1p1_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeP1p1 p P).readPrecomp q = m.readPrecomp q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPrecomp, readLimbs_storeP1p1_of_id_ne h,
    readLimbs_storeP1p1_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCached_storeP1p1_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeP1p1 p P).readCached q = m.readCached q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCached, readLimbs_storeP1p1_of_id_ne h,
    readLimbs_storeP1p1_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP1p1_storeP1p1_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeP1p1 p P).readP1p1 q = m.readP1p1 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP1p1, readLimbs_storeP1p1_of_id_ne h,
    readLimbs_storeP1p1_of_id_ne (h' _)]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeP1p1 {m : MemoryState} :
    (m.storeP1p1 p P).eraseFrom n = (m.eraseFrom n).storeP1p1 p P := by
  simp [MemoryState.storeP1p1, MemoryState.eraseFrom_storeLimbs]

@[mlir_frame, mlir_erase]
theorem MemoryState.storeP1p1_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeP1p1 p P = m.eraseFrom n := by
  simp [MemoryState.storeP1p1, MemoryState.storeLimbs_eraseFrom_of_le, Pointer.add, h]

/-- A `ge_p1p1` store into a block the erase removes: dropped before the erase moves inward. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeP1p1_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeP1p1 p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeP1p1, storeP1p1_eraseFrom_of_le h]

/-! ### `storeCached` -/

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storeCached_iff {m : MemoryState} :
    (m.storeCached p P).LimbsRoom q ↔ m.LimbsRoom q := by simp [MemoryState.storeCached]

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeCached {m : MemoryState} (h : m.LimbsFit q) :
    (m.storeCached p P).LimbsFit q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeCached {m : MemoryState} (h : m.LimbsRoom q) :
    (m.storeCached p P).LimbsRoom q :=
  limbsRoom_storeCached_iff.mpr h

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeCached {m : MemoryState} (h : m.PointFit q) :
    (m.storeCached p P).PointFit q :=
  ⟨h.1, h.2.1.storeCached, h.2.2.1.storeCached, h.2.2.2.1.storeCached, h.2.2.2.2.storeCached⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeCached {m : MemoryState} (h : m.PointRoom q) :
    (m.storeCached p P).PointRoom q :=
  ⟨h.1, h.2.1.storeCached, h.2.2.1.storeCached, h.2.2.2.1.storeCached, h.2.2.2.2.storeCached⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.storeCached {m : MemoryState} (h : m.Fe3Fit q) :
    (m.storeCached p P).Fe3Fit q :=
  ⟨h.1, h.2.1.storeCached, h.2.2.1.storeCached, h.2.2.2.storeCached⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.storeCached {m : MemoryState} (h : m.Fe3Room q) :
    (m.storeCached p P).Fe3Room q :=
  ⟨h.1, h.2.1.storeCached, h.2.2.1.storeCached, h.2.2.2.storeCached⟩

@[mlir_transport]
theorem Fits.storeCached {m : MemoryState} (h : Fits m q w) : Fits (m.storeCached p P) q w := by
  simp only [MemoryState.storeCached]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
theorem InBounds.storeCached {m : MemoryState} (h : InBounds m q w) :
    InBounds (m.storeCached p P) q w := by
  simp only [MemoryState.storeCached]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
theorem Room.storeCached {m : MemoryState} (h : Room m q w) : Room (m.storeCached p P) q w := by
  simp only [MemoryState.storeCached]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[simp, mlir_mem]
theorem GlobalState.WF_storeCached {s : GlobalState} :
    ({ s with mem := m.storeCached p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeCached]

@[mlir_transport]
theorem GlobalState.WF.storeCached {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeCached p P } : GlobalState).WF :=
  GlobalState.WF_storeCached.mpr h

/-- `WF.storeCached` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeCached_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeCached p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeCached (s := ⟨a, m⟩) h

@[mlir_read]
theorem MemoryState.readLimbs_storeCached_YplusX {m : MemoryState} {p : Pointer}
    (h : m.PointRoom p) : (m.storeCached p P).readLimbs p = P.YplusX := by
  simp only [MemoryState.storeCached]
  rw [readLimbs_storeLimbs_fe_of_X (a := 120) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_fe_of_X (a := 80) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_fe_of_X (a := 40) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.1]

@[mlir_read]
theorem MemoryState.readLimbs_storeCached_YminusX {m : MemoryState} {p : Pointer}
    (h : m.PointRoom p) : (m.storeCached p P).readLimbs (p.add 40#64) = P.YminusX := by
  simp only [MemoryState.storeCached]
  rw [readLimbs_storeLimbs_fe (a := 120) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_fe (a := 80) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.1.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storeCached_Z {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeCached p P).readLimbs (p.add 80#64) = P.Z := by
  simp only [MemoryState.storeCached]
  rw [readLimbs_storeLimbs_fe (a := 120) (b := 80) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storeCached_T2d {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeCached p P).readLimbs (p.add 120#64) = P.T2d := by
  simp only [MemoryState.storeCached]
  rw [readLimbs_storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readCached_storeCached_self {m : MemoryState} {p : Pointer}
    (h : m.PointRoom p) : (m.storeCached p P).readCached p = P := by
  simp only [MemoryState.readCached, readLimbs_storeCached_YplusX h,
    readLimbs_storeCached_YminusX h, readLimbs_storeCached_Z h, readLimbs_storeCached_T2d h]

/-- A `ge_cached` stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.PointFit.storeCached_self {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storeCached p P).PointFit p := by
  unfold MemoryState.storeCached
  exact
    ⟨h.1, (MemoryState.LimbsFit.storeLimbs_self h.2.1).storeLimbs.storeLimbs.storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.1.storeLimbs).storeLimbs.storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs).storeLimbs,
      (MemoryState.LimbsFit.storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs.storeLimbs)⟩

@[mlir_read]
theorem MemoryState.readLimbs_storeCached_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeCached p P).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeCached, readLimbs_storeLimbs_of_id_ne (h' _),
    readLimbs_storeLimbs_of_id_ne h]

@[mlir_read]
theorem MemoryState.readAt_storeCached_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeCached p P).readAt q w = m.readAt q w := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  have h40 := h' 40#64
  have h80 := h' 80#64
  have h120 := h' 120#64
  simp only [MemoryState.storeCached, MemoryState.storeLimbs, Tactic.readThroughStore]

@[mlir_read]
theorem MemoryState.readP2_storeCached_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeCached p P).readP2 q = m.readP2 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP2, readLimbs_storeCached_of_id_ne h,
    readLimbs_storeCached_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP3_storeCached_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeCached p P).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP3, readLimbs_storeCached_of_id_ne h,
    readLimbs_storeCached_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readP1p1_storeCached_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeCached p P).readP1p1 q = m.readP1p1 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP1p1, readLimbs_storeCached_of_id_ne h,
    readLimbs_storeCached_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readPrecomp_storeCached_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeCached p P).readPrecomp q = m.readPrecomp q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPrecomp, readLimbs_storeCached_of_id_ne h,
    readLimbs_storeCached_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCached_storeCached_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeCached p P).readCached q = m.readCached q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCached, readLimbs_storeCached_of_id_ne h,
    readLimbs_storeCached_of_id_ne (h' _)]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeCached {m : MemoryState} :
    (m.storeCached p P).eraseFrom n = (m.eraseFrom n).storeCached p P := by
  simp [MemoryState.storeCached, MemoryState.eraseFrom_storeLimbs]

@[mlir_frame, mlir_erase]
theorem MemoryState.storeCached_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeCached p P = m.eraseFrom n := by
  simp [MemoryState.storeCached, MemoryState.storeLimbs_eraseFrom_of_le, Pointer.add, h]

/-- A `ge_cached` store into a block the erase removes: dropped before the erase moves inward. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeCached_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeCached p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeCached, storeCached_eraseFrom_of_le h]

/-! ### Store orders -/

/-- A `ge_p1p1` stored as `X, Y, T`, then `X, Y, Z, T` over them (the additions' order). -/
theorem MemoryState.storeP1p1_of_XYTXYZT {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    ((((((m.storeLimbs p X₁).storeLimbs (p.add 40#64) Y₁).storeLimbs (p.add 120#64) T₁).storeLimbs p
                    X).storeLimbs
                (p.add 40#64) Y).storeLimbs
            (p.add 80#64) Z).storeLimbs
        (p.add 120#64) T =
      m.storeP1p1 p ⟨X, Y, Z, T⟩ := by
  rw [storeLimbs_comm_fe_X (a := 120) hp (by omega) (by omega),
    storeLimbs_comm_fe_X (a := 40) hp (by omega) (by omega), storeLimbs_storeLimbs_self,
    storeLimbs_comm_fe (a := 120) (b := 40) hp (by omega) (by omega) (by omega),
    storeLimbs_storeLimbs_self,
    storeLimbs_comm_fe (a := 120) (b := 80) hp (by omega) (by omega) (by omega),
    storeLimbs_storeLimbs_self]
  rfl

-- last among the transports: tried after the structural ones, which carry a `…Room` fact
-- directly, so they do not search the `…Fit` facts first
attribute [-mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room

attribute [mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room
  MemoryState.Fe3Fit.room

end

end MLIR
