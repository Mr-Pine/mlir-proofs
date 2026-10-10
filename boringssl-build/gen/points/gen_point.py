#!/usr/bin/env python3
"""Generate Boringssl/Common/Point.lean: ref10 point objects and their memory lemmas."""
import sys

OFFS = [0, 40, 80, 120]

# objects: name, fields, C type, doc
OBJS = {
    "P2": (["X", "Y", "Z"], "ge_p2", "projective `(X : Y : Z)`"),
    "P3": (["X", "Y", "Z", "T"], "ge_p3", "extended `(X : Y : Z : T)`"),
    "P1p1": (["X", "Y", "Z", "T"], "ge_p1p1", "completed `((X : Z), (Y : T))`"),
    "Precomp": (["yplusx", "yminusx", "xy2d"], "ge_precomp", "`(y + x, y - x, 2d x y)`"),
    "Cached": (["YplusX", "YminusX", "Z", "T2d"], "ge_cached", "`(Y + X, Y - X, Z, 2d T)`"),
}
STORES = ["P2", "P3", "P1p1", "Cached"]
READS = ["P2", "P3", "P1p1", "Precomp", "Cached"]


def ptr(k, p="p"):
    return p if k == 0 else f"({p}.add {k}#64)"


def n_of(o):
    return len(OBJS[o][0])


def fit(o):
    return "PointFit" if n_of(o) == 4 else "Fe3Fit"


def room(o):
    return "PointRoom" if n_of(o) == 4 else "Fe3Room"


def conj(n, i):
    """Projection of the i-th field element from an object predicate `h` (offset bound first)."""
    s = "h" + ".2" * (i + 1)
    if i < n - 1:
        s += ".1"
    return s


out = []
w = out.append

w("""module

public import Firedancer.Common.Point
import Std.Data.ExtHashMap.Lemmas
import MLIR.Run.Tactic.Memory
import Mathlib.Tactic.FinCases

/-! ref10's points in memory: `ge_p2`, `ge_p3`, `ge_p1p1`, `ge_precomp` and `ge_cached`, their field
elements at byte offsets 0, 40, 80 (and 120), read and stored as a whole. A point of four field
elements fits as `PointFit` (Firedancer's points have the same layout), one of three as `Fe3Fit`. -/

namespace MLIR

open Memory

@[expose] public section

/-! ### Objects -/
""")

for o in READS:
    fields, cty, doc = OBJS[o]
    w(f"/-- `{cty}`: {doc}. -/")
    w(f"structure Ge{o} where")
    for f in fields:
        w(f"  {f} : Fin 5 → BitVec 64")
    w("")

for o in READS:
    fields, cty, _ = OBJS[o]
    args = ", ".join(f"m.readLimbs {ptr(k)}".replace("(p.add", "(p.add") for k in OFFS[: len(fields)])
    w(f"/-- The `{cty}` at `p`. -/")
    w(f"def MemoryState.read{o} (m : MemoryState) (p : Pointer) : Ge{o} :=")
    w(f"  ⟨{args}⟩")
    w("")

for o in STORES:
    fields, cty, _ = OBJS[o]
    s = "m"
    for k, f in zip(OFFS, fields):
        s = f"({s}.storeLimbs {ptr(k)} P.{f})"
    s = s[1:-1]
    w(f"/-- Store the `{cty}` `P` at `p`, field by field. -/")
    w(f"def MemoryState.store{o} (m : MemoryState) (p : Pointer) (P : Ge{o}) : MemoryState :=")
    w(f"  {s}")
    w("")

w("""/-- The three field elements at `p` fit (`ge_p2`, `ge_precomp`): offsets do not wrap, each fits. -/
abbrev MemoryState.Fe3Fit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 120 ≤ 2 ^ 64 ∧ m.LimbsFit p ∧ m.LimbsFit (p.add 40#64) ∧ m.LimbsFit (p.add 80#64)

/-- Room for the three field elements at `p`: offsets do not wrap, room for each. -/
abbrev MemoryState.Fe3Room (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 120 ≤ 2 ^ 64 ∧ m.LimbsRoom p ∧ m.LimbsRoom (p.add 40#64) ∧
    m.LimbsRoom (p.add 80#64)

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

/-- Two field elements at byte offsets `a` and `b`, 40 apart, of an object of `n` bytes. -/
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
  storeLimbs_comm (Pointer.fe_offset hp ha) (Pointer.fe_offset hp hb) (Range.disjoint_fe hp ha hb hab)

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
  exact ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Fit.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.Fe3Fit p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).Fe3Fit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.lifetimeEnd (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Fe3Room.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.Fe3Room p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).Fe3Room p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.lifetimeStart (hne' _)⟩

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
""")

# reads past writes of other kinds
for o in READS:
    fields = OBJS[o][0]
    n = len(fields)
    w(f"/-! ### `read{o}` past other writes -/")
    w("")
    w("@[mlir_read]")
    w(f"theorem MemoryState.read{o}_storeLimbs_of_id_ne {{m : MemoryState}} {{p q : Pointer}}")
    w(f"    (h : p.id ≠ q.id) : (m.storeLimbs p l).read{o} q = m.read{o} q := by")
    w("  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h")
    w(f"  simp only [MemoryState.read{o}, readLimbs_storeLimbs_of_id_ne h,")
    w("    readLimbs_storeLimbs_of_id_ne (h' _)]")
    w("")
    w("@[mlir_read]")
    w(f"theorem MemoryState.read{o}_storeAt_of_id_ne {{m : MemoryState}} {{p q : Pointer}} {{x : BitVec w}}")
    w(f"    (h : p.id ≠ q.id) : (m.storeAt p x).read{o} q = m.read{o} q := by")
    w("  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h")
    w("  have h0 := h' 0")
    w("  have h8 := h' 8#64")
    w(f"  simp only [MemoryState.read{o}]")
    w("  congr 1 <;> funext i <;> fin_cases i <;>")
    w("    simp only [MemoryState.readLimbs, Pointer.add_add, Tactic.readThroughStore]")
    w("")
    w("@[mlir_frame, mlir_read]")
    w(f"theorem MemoryState.read{o}_alloca {{s : GlobalState}} (hne : p.id ≠ s.allocaPtr.id) :")
    w(f"    (s.alloca n d).mem.read{o} p = s.mem.read{o} p := by")
    w("  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne")
    w(f"  simp only [MemoryState.read{o}, readLimbs_alloca hne, readLimbs_alloca (hne' _)]")
    w("")
    w("@[mlir_read]")
    w(f"theorem MemoryState.read{o}_addBlock_of_id_ne {{m : MemoryState}} {{x : BitVec v}} (h : p.id ≠ b) :")
    w(f"    (m.addBlock b n x).read{o} p = m.read{o} p := by")
    w("  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h")
    w(f"  simp only [MemoryState.read{o}, readLimbs_addBlock_of_id_ne h,")
    w("    readLimbs_addBlock_of_id_ne (h' _)]")
    w("")
    for lt in ["lifetimeStart", "lifetimeEnd"]:
        w("/-- A lifetime marker keeps the bits. -/")
        w("@[mlir_read]")
        w(f"theorem MemoryState.read{o}_{lt} {{m : MemoryState}} :")
        w(f"    (m.{lt} q).read{o} p = m.read{o} p := by")
        w(f"  simp only [MemoryState.read{o}, readLimbs_{lt}]")
        w("")

for o in STORES:
    fields, cty, _ = OBJS[o]
    n = len(fields)
    F, R = fit(o), room(o)
    size = 40 * n
    w(f"/-! ### `store{o}` -/")
    w("")
    w("@[simp, mlir_state]")
    w(f"theorem MemoryState.limbsRoom_store{o}_iff {{m : MemoryState}} :")
    w(f"    (m.store{o} p P).LimbsRoom q ↔ m.LimbsRoom q := by simp [MemoryState.store{o}]")
    w("")
    chain = ".storeLimbs" * n
    w("@[mlir_mem, mlir_transport]")
    w(f"theorem MemoryState.LimbsFit.store{o} {{m : MemoryState}} (h : m.LimbsFit q) :")
    w(f"    (m.store{o} p P).LimbsFit q :=")
    w(f"  h{chain}")
    w("")
    w("@[mlir_mem, mlir_transport]")
    w(f"theorem MemoryState.LimbsRoom.store{o} {{m : MemoryState}} (h : m.LimbsRoom q) :")
    w(f"    (m.store{o} p P).LimbsRoom q :=")
    w(f"  limbsRoom_store{o}_iff.mpr h")
    w("")
    for (pf, pn) in [("PointFit", 4), ("PointRoom", 4), ("Fe3Fit", 3), ("Fe3Room", 3)]:
        parts = ", ".join(f"{conj(pn, i)}.store{o}" for i in range(pn))
        w("@[mlir_mem, mlir_transport]")
        w(f"theorem MemoryState.{pf}.store{o} {{m : MemoryState}} (h : m.{pf} q) :")
        w(f"    (m.store{o} p P).{pf} q :=")
        w(f"  ⟨h.1, {parts}⟩")
        w("")
    for k in ["Fits", "InBounds", "Room"]:
        w("@[mlir_transport]")
        w(f"theorem {k}.store{o} {{m : MemoryState}} (h : {k} m q w) : {k} (m.store{o} p P) q w := by")
        w(f"  simp only [MemoryState.store{o}]")
        w(f"  exact h{chain}")
        w("")
    w("@[simp, mlir_mem]")
    w(f"theorem GlobalState.WF_store{o} {{s : GlobalState}} :")
    w(f"    ({{ s with mem := m.store{o} p P }} : GlobalState).WF ↔ ({{ s with mem := m }} : GlobalState).WF := by")
    w(f"  simp [MemoryState.store{o}]")
    w("")
    w("@[mlir_transport]")
    w(f"theorem GlobalState.WF.store{o} {{s : GlobalState}} (h : s.WF) :")
    w(f"    ({{ s with mem := s.mem.store{o} p P }} : GlobalState).WF :=")
    w(f"  GlobalState.WF_store{o}.mpr h")
    w("")
    w(f"/-- `WF.store{o}` for a state written as a constructor, which unifies first-order. -/")
    w("@[mlir_transport]")
    w(f"theorem GlobalState.WF.store{o}_mk {{a : AllocState}} {{m : MemoryState}}")
    w(f"    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.store{o} p P⟩ : GlobalState).WF :=")
    w(f"  GlobalState.WF.store{o} (s := ⟨a, m⟩) h")
    w("")
    # coordinate reads of the object stored
    for i, (k, f) in enumerate(zip(OFFS, fields)):
        rws = []
        for j in range(n - 1, i, -1):
            kj = OFFS[j]
            if k == 0:
                rws.append(f"readLimbs_storeLimbs_fe_of_X (a := {kj}) h.1 (by omega) (by omega)")
            else:
                rws.append(f"readLimbs_storeLimbs_fe (a := {kj}) (b := {k}) h.1 (by omega) (by omega) (by omega)")
        selfh = conj(n, i) + ".storeLimbs" * i
        rws.append(f"readLimbs_storeLimbs_self {selfh}")
        w("@[mlir_read]")
        w(f"theorem MemoryState.readLimbs_store{o}_{f} {{m : MemoryState}} {{p : Pointer}} (h : m.{R} p) :")
        w(f"    (m.store{o} p P).readLimbs {ptr(k)} = P.{f} := by")
        w(f"  simp only [MemoryState.store{o}]")
        w("  rw [" + ",\n    ".join(rws) + "]")
        w("")
    w("@[mlir_read]")
    w(f"theorem MemoryState.read{o}_store{o}_self {{m : MemoryState}} {{p : Pointer}} (h : m.{R} p) :")
    w(f"    (m.store{o} p P).read{o} p = P := by")
    w(f"  simp only [MemoryState.read{o}, " + ", ".join(f"readLimbs_store{o}_{f} h" for f in fields) + "]")
    w("")
    w(f"/-- A `{cty}` stored where there is room is known. -/")
    w("@[mlir_fresh, mlir_mem]")
    w(f"theorem MemoryState.{F}.store{o}_self {{m : MemoryState}} {{p : Pointer}} (h : m.{R} p) :")
    w(f"    (m.store{o} p P).{F} p := by")
    w(f"  unfold MemoryState.store{o}")
    parts = []
    for i in range(n):
        inner = f"(MemoryState.LimbsFit.storeLimbs_self {conj(n, i)}{'.storeLimbs' * i})"
        parts.append(inner + ".storeLimbs" * (n - 1 - i))
    w("  exact ⟨h.1, " + ",\n    ".join(parts) + "⟩")
    w("")
    w("@[mlir_read]")
    w(f"theorem MemoryState.readLimbs_store{o}_of_id_ne {{m : MemoryState}} {{p q : Pointer}}")
    w(f"    (h : p.id ≠ q.id) : (m.store{o} p P).readLimbs q = m.readLimbs q := by")
    w("  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h")
    w(f"  simp only [MemoryState.store{o}, readLimbs_storeLimbs_of_id_ne (h' _),")
    w("    readLimbs_storeLimbs_of_id_ne h]")
    w("")
    w("@[mlir_read]")
    w(f"theorem MemoryState.readAt_store{o}_of_id_ne {{m : MemoryState}} {{p q : Pointer}} (h : p.id ≠ q.id) :")
    w(f"    (m.store{o} p P).readAt q w = m.readAt q w := by")
    w("  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h")
    for k in OFFS[1:n]:
        w(f"  have h{k} := h' {k}#64")
    w(f"  simp only [MemoryState.store{o}, MemoryState.storeLimbs, Tactic.readThroughStore]")
    w("")
    for r in READS:
        if r == o:
            continue
        w("@[mlir_read]")
        w(f"theorem MemoryState.read{r}_store{o}_of_id_ne {{m : MemoryState}} {{p q : Pointer}}")
        w(f"    (h : p.id ≠ q.id) : (m.store{o} p P).read{r} q = m.read{r} q := by")
        w("  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h")
        w(f"  simp only [MemoryState.read{r}, readLimbs_store{o}_of_id_ne h,")
        w(f"    readLimbs_store{o}_of_id_ne (h' _)]")
        w("")
    w("@[mlir_read]")
    w(f"theorem MemoryState.read{o}_store{o}_of_id_ne {{m : MemoryState}} {{p q : Pointer}}")
    w(f"    (h : p.id ≠ q.id) : (m.store{o} p P).read{o} q = m.read{o} q := by")
    w("  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h")
    w(f"  simp only [MemoryState.read{o}, readLimbs_store{o}_of_id_ne h,")
    w(f"    readLimbs_store{o}_of_id_ne (h' _)]")
    w("")
    w("@[mlir_frame, mlir_erase]")
    w(f"theorem MemoryState.eraseFrom_store{o} {{m : MemoryState}} :")
    w(f"    (m.store{o} p P).eraseFrom n = (m.eraseFrom n).store{o} p P := by")
    w(f"  simp [MemoryState.store{o}, MemoryState.eraseFrom_storeLimbs]")
    w("")
    w("@[mlir_frame, mlir_erase]")
    w(f"theorem MemoryState.store{o}_eraseFrom_of_le {{m : MemoryState}} (h : n ≤ p.id.id) :")
    w(f"    (m.eraseFrom n).store{o} p P = m.eraseFrom n := by")
    w(f"  simp [MemoryState.store{o}, MemoryState.storeLimbs_eraseFrom_of_le, Pointer.add, h]")
    w("")
    w(f"/-- A `{cty}` store into a block the erase removes: dropped before the erase moves inward. -/")
    w("@[mlir_erase high]")
    w(f"theorem MemoryState.eraseFrom_store{o}_of_le {{m : MemoryState}} (h : n ≤ p.id.id) :")
    w(f"    (m.store{o} p P).eraseFrom n = m.eraseFrom n := by")
    w(f"  rw [eraseFrom_store{o}, store{o}_eraseFrom_of_le h]")
    w("")

w("""/-! ### Store orders -/

/-- A `ge_p1p1` stored as `X, Y, T`, then `X, Y, Z, T` over them (the additions' order). -/
theorem MemoryState.storeP1p1_of_XYTXYZT {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    ((((((m.storeLimbs p X₁).storeLimbs (p.add 40#64) Y₁).storeLimbs (p.add 120#64) T₁).storeLimbs
                p X).storeLimbs (p.add 40#64) Y).storeLimbs (p.add 80#64) Z).storeLimbs
        (p.add 120#64) T =
      m.storeP1p1 p ⟨X, Y, Z, T⟩ := by
  rw [storeLimbs_comm_fe_X (a := 120) hp (by omega) (by omega),
    storeLimbs_comm_fe_X (a := 40) hp (by omega) (by omega), storeLimbs_storeLimbs_self,
    storeLimbs_comm_fe (a := 120) (b := 40) hp (by omega) (by omega) (by omega),
    storeLimbs_storeLimbs_self,
    storeLimbs_comm_fe (a := 120) (b := 80) hp (by omega) (by omega) (by omega),
    storeLimbs_storeLimbs_self]
  rfl
""")

w("""-- last among the transports: tried after the structural ones, which carry a `…Room` fact
-- directly, so they do not search the `…Fit` facts first
attribute [-mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room

attribute [mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room
  MemoryState.Fe3Fit.room

end

end MLIR""")

print("\n".join(out))
