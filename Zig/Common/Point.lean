module

public import Zig.Common.Fe
import Std.Data.ExtHashMap.Lemmas
import MLIR.Run.Tactic.Memory
import Std.Tactic.BVDecide

/-! Points as Zig's `Edwards25519` holds them: field elements `x, y, z, t` at byte offsets 0, 40,
80, 120, the `i1` `is_base` at 160, then padding; 168 bytes in all. Only the four field elements
and `is_base`'s bit are ever defined, so a point is known by those (`PtFit`), and copied whole with
its definedness. -/

namespace MLIR.Zig

open Memory

@[expose] public section

/-- A point's field elements. -/
structure ZPt where
  x : Fin 5 → BitVec 64
  y : Fin 5 → BitVec 64
  z : Fin 5 → BitVec 64
  t : Fin 5 → BitVec 64

/-- The point at `p`. -/
def _root_.MLIR.MemoryState.readPt (m : MemoryState) (p : Pointer) : ZPt :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- `is_base` of the point at `p`. -/
def _root_.MLIR.MemoryState.readBase (m : MemoryState) (p : Pointer) : BitVec 1 :=
  m.readAt (p.add 160#64) 1

/-- Store a point and its `is_base` at `p`, as the code does: `x, y, z, t`, then `is_base`. -/
def _root_.MLIR.MemoryState.storePt (m : MemoryState) (p : Pointer) (P : ZPt) (b : BitVec 1) :
    MemoryState :=
  ((((m.storeLimbs p P.x).storeLimbs (p.add 40#64) P.y).storeLimbs (p.add 80#64) P.z).storeLimbs
        (p.add 120#64) P.t).storeAt
    (p.add 160#64) b

/-- Room for the point at `p` (an output), its offsets not wrapping. -/
abbrev _root_.MLIR.MemoryState.PtRoom (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 168 ≤ 2 ^ 64 ∧ Room m p 1344

/-- The point at `p` is live (an input, maybe read-only), its offsets not wrapping. -/
abbrev _root_.MLIR.MemoryState.PtLive (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 168 ≤ 2 ^ 64 ∧ Live m p 1344

/-- The point at `p` is known: live, its field elements and `is_base` known. -/
abbrev _root_.MLIR.MemoryState.PtFit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 168 ≤ 2 ^ 64 ∧
    Live m p 1344 ∧
    m.LimbsFit p ∧
    m.LimbsFit (p.add 40#64) ∧
    m.LimbsFit (p.add 80#64) ∧ m.LimbsFit (p.add 120#64) ∧ Fits m (p.add 160#64) 1

attribute [mlir_mem] MemoryState.PtRoom MemoryState.PtFit MemoryState.PtLive

/-- The point's 160 bytes of field elements. -/
def ZPt.bits (P : ZPt) : BitVec 1280 :=
  limbsBits P.t ++ limbsBits P.z ++ limbsBits P.y ++ limbsBits P.x

/-- Each coordinate's limbs are below `B`. -/
def ZPt.Lt (P : ZPt) (B : ℕ) : Prop :=
  Fe.Lt P.x B ∧ Fe.Lt P.y B ∧ Fe.Lt P.z B ∧ Fe.Lt P.t B

end

public theorem ZPt.Lt.mono {P : ZPt} {a b : ℕ} (h : P.Lt a) (hab : a ≤ b) : P.Lt b :=
  ⟨h.1.mono hab, h.2.1.mono hab, h.2.2.1.mono hab, h.2.2.2.mono hab⟩

/-- Limbs below `2^52` are below `2^53`. -/
public theorem ZPt.Lt.mono53 {P : ZPt} (h : P.Lt (2 ^ 52)) : P.Lt (2 ^ 53) :=
  h.mono (by decide)

/-! ### Offsets inside a point -/

/-- An offset inside a point does not wrap. -/
public theorem _root_.MLIR.Pointer.not_uaddOverflow_of_pt {p : Pointer}
    (hp : p.offset.toNat + 168 ≤ 2 ^ 64) {k : BitVec 64} (hk : k.toNat < 168) :
    ¬p.offset.uaddOverflow k := by
  simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]
  omega

/-- A field's offset does not wrap, in a point whose offsets do not. -/
public theorem _root_.MLIR.Pointer.field_offset {p : Pointer} (hp : p.offset.toNat + 168 ≤ 2 ^ 64)
    {a : Nat} (ha : a ≤ 120) : (p.add (BitVec.ofNat 64 a)).offset.toNat + 32 < 2 ^ 64 := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  omega

/-- Room for a field element `k` bytes into a point's room. -/
public theorem _root_.MLIR.MemoryState.LimbsRoom.of_pt {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) {k : BitVec 64} (hk : k.toNat ≤ 128) : m.LimbsRoom (p.add k) := by
  have hr : Room m (p.add k) 320 :=
    Room.add_of_le (p.not_uaddOverflow_of_pt h.1 (by omega)) (by omega) h.2
  have hoff : (p.add k).offset.toNat = p.offset.toNat + k.toNat := by
    simp only [Pointer.add, BitVec.toNat_add]; omega
  have hov (off : BitVec 64) (hoff' : off.toNat ≤ 32) : ¬(p.add k).offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, hoff]
    have := h.1
    omega
  refine
      ⟨by
        have := h.1; omega, hr.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (hov _ (by decide)) (by decide) hr

/-- Firedancer's point room (field elements at 0, 40, 80, 120) inside a Zig point's. -/
@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.pointRoom {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : m.PointRoom p :=
  ⟨by
    have := h.1; omega, by
    simpa [Pointer.add_zero] using MemoryState.LimbsRoom.of_pt h (k := 0#64) (by decide),
    .of_pt h (by decide), .of_pt h (by decide), .of_pt h (by decide)⟩

/-- A point's room, its bytes'. -/
@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.room {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : Room m p 1344 :=
  h.2

/-- Room for a point's `is_base`. -/
@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.room_base {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : Room m (p.add 160#64) 1 :=
  Room.add_of_le (p.not_uaddOverflow_of_pt h.1 (by decide)) (by decide) h.2

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.limbsRoom_x {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : m.LimbsRoom p :=
  h.pointRoom.2.1

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.limbsRoom_y {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : m.LimbsRoom (p.add 40#64) :=
  .of_pt h (by decide)

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.limbsRoom_z {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : m.LimbsRoom (p.add 80#64) :=
  .of_pt h (by decide)

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.limbsRoom_t {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : m.LimbsRoom (p.add 120#64) :=
  .of_pt h (by decide)

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.limbsFit_x {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.LimbsFit p :=
  h.2.2.1

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.limbsFit_y {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.LimbsFit (p.add 40#64) :=
  h.2.2.2.1

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.limbsFit_z {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.LimbsFit (p.add 80#64) :=
  h.2.2.2.2.1

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.limbsFit_t {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.LimbsFit (p.add 120#64) :=
  h.2.2.2.2.2.1

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.fits_base {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : Fits m (p.add 160#64) 1 :=
  h.2.2.2.2.2.2

/-- A known point in a writable block: room for it. -/
public theorem _root_.MLIR.MemoryState.PtFit.room {m : MemoryState} {p : Pointer} (h : m.PtFit p)
    (hw : Writable m p) : m.PtRoom p :=
  ⟨h.1, h.2.1, hw⟩

/-- A known point is live. -/
@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.ptLive {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.PtLive p :=
  ⟨h.1, h.2.1⟩

/-- Room for a point: it is live. -/
@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.ptLive {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : m.PtLive p :=
  ⟨h.1, h.2.1⟩

/-- A live 168-byte block from its start holds a point (a global's). -/
@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLive.of_live {m : MemoryState} {p : Pointer}
    (h : Live m p 1344) (ho : p.offset = 0) : m.PtLive p :=
  ⟨by simp [ho], h⟩

/-- A 168-byte live block from its start has room for one point. -/
public theorem _root_.MLIR.MemoryState.PtRoom.of_room {m : MemoryState} {p : Pointer}
    (h : Room m p 1344) (ho : p.offset = 0) : m.PtRoom p :=
  ⟨by simp [ho], h⟩

/-- A known point from its known bits: the field elements and `is_base`'s. -/
public theorem _root_.MLIR.MemoryState.PtFit.of_fits {m : MemoryState} {p : Pointer}
    (hr : Live m p 1344) (hf : Fits m p 1281) (ho : p.offset.toNat + 168 ≤ 2 ^ 64) : m.PtFit p := by
  have hc (k : BitVec 64) (hk : k.toNat ≤ 120) : m.LimbsFit (p.add k) :=
    .of_fits' (Fits.add_of_le (p.not_uaddOverflow_of_pt ho (by omega)) (by omega) hf)
      (by
        simp only [Pointer.add, BitVec.toNat_add]; omega)
  exact
    ⟨ho, hr, .of_fits' (hf.mono (by omega)) (by omega), hc _ (by decide), hc _ (by decide),
      hc _ (by decide), Fits.add_of_le (p.not_uaddOverflow_of_pt ho (by decide)) (by decide) hf⟩

/-- The field elements' slices of a point's bits. -/
theorem ZPt.extractLsb'_bits (P : ZPt) :
    (fun i : Fin 5 => P.bits.extractLsb' (64 * i.val) 64) = P.x ∧
      (fun i : Fin 5 => P.bits.extractLsb' (320 + 64 * i.val) 64) = P.y ∧
      (fun i : Fin 5 => P.bits.extractLsb' (640 + 64 * i.val) 64) = P.z ∧
      (fun i : Fin 5 => P.bits.extractLsb' (960 + 64 * i.val) 64) = P.t := by
  obtain ⟨x, y, z, t⟩ := P
  rw [Fe.eta5 x, Fe.eta5 y, Fe.eta5 z, Fe.eta5 t]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> funext i <;> fin_cases i <;>
    simp only [ZPt.bits, limbsBits, Fe.mk5, Fin.isValue] <;>
    bv_decide

/-- The field element at byte offset `k` of a range read whole: its bits there. -/
theorem readLimbs_of_readAt_add {m : MemoryState} {p : Pointer} {x : BitVec v} {k : Nat}
    (hf : InBounds m p v) (ho : p.offset.toNat + k + 40 ≤ 2 ^ 64) (hk : 8 * k + 320 ≤ v)
    (h : m.readAt p v = x) :
    m.readLimbs (p.add (BitVec.ofNat 64 k)) = fun i => x.extractLsb' (8 * k + 64 * i.val) 64 := by
  have hread (q : Nat) (hq : q ≤ 4) :
    m.readAt (p.add (BitVec.ofNat 64 (k + 8 * q))) 64 = x.extractLsb' (8 * k + 64 * q) 64 := by
    rw [MemoryState.readAt_add_of_readAt (w := 64) hf
        (by
          simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le]
          rw [Nat.mod_eq_of_lt (by omega)]; omega)
        (by
          rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)
        h,
      BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    congr 1
    omega
  have hadd (q : Nat) :
    (p.add (BitVec.ofNat 64 k)).add (BitVec.ofNat 64 (8 * q)) =
      p.add (BitVec.ofNat 64 (k + 8 * q)) := by
    rw [Pointer.add_add, BitVec.ofNat_add]
  funext i
  fin_cases i
  · simpa [MemoryState.readLimbs] using hread 0 (by omega)
  · simpa [MemoryState.readLimbs, ← hadd 1] using hread 1 (by omega)
  · simpa [MemoryState.readLimbs, ← hadd 2] using hread 2 (by omega)
  · simpa [MemoryState.readLimbs, ← hadd 3] using hread 3 (by omega)
  · simpa [MemoryState.readLimbs, ← hadd 4] using hread 4 (by omega)

/-- A point read back from its field elements' bits. -/
public theorem _root_.MLIR.MemoryState.readPt_of_readAt {m : MemoryState} {p : Pointer} {P : ZPt}
    (hb : InBounds m p 1280) (ho : p.offset.toNat + 168 ≤ 2 ^ 64) (h : m.readAt p 1280 = P.bits) :
    m.readPt p = P := by
  obtain ⟨sx, sy, sz, st⟩ := ZPt.extractLsb'_bits P
  have h0 := readLimbs_of_readAt_add (k := 0) hb (by omega) (by omega) h
  have h40 := readLimbs_of_readAt_add (k := 40) hb (by omega) (by omega) h
  have h80 := readLimbs_of_readAt_add (k := 80) hb (by omega) (by omega) h
  have h120 := readLimbs_of_readAt_add (k := 120) hb (by omega) (by omega) h
  simp only [Nat.mul_zero, Nat.zero_add, Pointer.add_zero'] at h0
  simp only [Nat.reduceMul] at h40 h80 h120
  simp only [MemoryState.readPt, h0, h40, h80, h120, sx, sy, sz, st]

/-! ### Reads past stores -/

/-- Limbs read past a store to a range apart from theirs. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readLimbs_storeAt_of_disjoint {m : MemoryState}
    {p q : Pointer} {x : BitVec w} (h : (Range.of q w).Disjoint (Range.of p 320))
    (hp : p.offset.toNat + 32 < 2 ^ 64) : (m.storeAt q x).readLimbs p = m.readLimbs p := by
  have hd (k : Nat) (hk : k ≤ 32) := (Range.disjoint_limb (k := k) hp hk h).symm
  have h0 : (Range.of q w).Disjoint (Range.of p 64) := by
    simpa [Pointer.add_zero'] using hd 0 (by omega)
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs]
  · exact MemoryState.readAt_storeAt_disjoint h0 x
  all_goals exact MemoryState.readAt_storeAt_disjoint (hd _ (by decide)) x

/-- `is_base` and a coordinate of one point do not overlap. -/
theorem Range.disjoint_base_coord {p : Pointer} (hp : p.offset.toNat + 168 ≤ 2 ^ 64) {a : Nat}
    (ha : a ≤ 120) :
    (Range.of (p.add 160#64) 1).Disjoint (Range.of (p.add (BitVec.ofNat 64 a)) 320) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right; right
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega : 160 < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A coordinate read past a store to `is_base`. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readLimbs_storeAt_base {m : MemoryState} {p : Pointer}
    {a : Nat} (h : m.PtRoom p) (ha : a ≤ 120) {x : BitVec 1} :
    (m.storeAt (p.add 160#64) x).readLimbs (p.add (BitVec.ofNat 64 a)) =
      m.readLimbs (p.add (BitVec.ofNat 64 a)) :=
  MemoryState.readLimbs_storeAt_of_disjoint (Range.disjoint_base_coord h.1 ha)
    (Pointer.field_offset h.1 ha)

/-- `x` read past a store to `is_base`. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readLimbs_storeAt_base_x {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) {x : BitVec 1} : (m.storeAt (p.add 160#64) x).readLimbs p = m.readLimbs p := by
  simpa [Pointer.add_zero'] using MemoryState.readLimbs_storeAt_base (a := 0) (x := x) h (by omega)

/-- `is_base` read past a store to a coordinate. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storeLimbs_coord {m : MemoryState} {p : Pointer}
    {a : Nat} (h : m.PtRoom p) (ha : a ≤ 120) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readBase p = m.readBase p := by
  have hd (k : Nat) (hk : k ≤ 32) :=
    Range.disjoint_limb (k := k) (Pointer.field_offset h.1 ha) hk (Range.disjoint_base_coord h.1 ha)
  have h0 : (Range.of (p.add (BitVec.ofNat 64 a)) 64).Disjoint (Range.of (p.add 160#64) 1) := by
    simpa [Pointer.add_zero'] using hd 0 (by omega)
  simp only [MemoryState.readBase, MemoryState.storeLimbs]
  rw [MemoryState.readAt_storeAt_disjoint (hd 32 (by omega)),
    MemoryState.readAt_storeAt_disjoint (hd 24 (by omega)),
    MemoryState.readAt_storeAt_disjoint (hd 16 (by omega)),
    MemoryState.readAt_storeAt_disjoint (hd 8 (by omega)), MemoryState.readAt_storeAt_disjoint h0]

/-- `is_base` read past a store to `x`. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storeLimbs_x {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storeLimbs p l).readBase p = m.readBase p := by
  simpa [Pointer.add_zero'] using
    MemoryState.readBase_storeLimbs_coord (a := 0) (l := l) h (by omega)

/-- A stored `is_base` reads back. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storeAt_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) {x : BitVec 1} : (m.storeAt (p.add 160#64) x).readBase p = x :=
  MemoryState.readAt_storeAt_self h.room_base x

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_storePt_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storePt p P b).readPt p = P := by
  have hr := h.pointRoom
  obtain ⟨x, y, z, t⟩ := P
  simp only [MemoryState.readPt, MemoryState.storePt, ZPt.mk.injEq]
  have h4 :
    ((((m.storeLimbs p x).storeLimbs (p.add 40#64) y).storeLimbs (p.add 80#64) z).storeLimbs
          (p.add 120#64) t).PtRoom
      p := by
    simpa [MemoryState.PtRoom] using h
  rw [MemoryState.readLimbs_storeAt_base_x h4,
    MemoryState.readLimbs_storeAt_base h4 (a := 40) (by omega),
    MemoryState.readLimbs_storeAt_base h4 (a := 80) (by omega),
    MemoryState.readLimbs_storeAt_base h4 (a := 120) (by omega)]
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [MemoryState.readLimbs_storeLimbs_coord_of_X (a := 120) hr.storeLimbs.storeLimbs.storeLimbs
        (by omega) (by omega),
      MemoryState.readLimbs_storeLimbs_coord_of_X (a := 80) hr.storeLimbs.storeLimbs (by omega)
        (by omega),
      MemoryState.readLimbs_storeLimbs_coord_of_X (a := 40) hr.storeLimbs (by omega) (by omega),
      MemoryState.readLimbs_storeLimbs_self hr.2.1]
  · rw [MemoryState.readLimbs_storeLimbs_coord (a := 120) (b := 40)
        hr.storeLimbs.storeLimbs.storeLimbs (by omega) (by omega) (by omega),
      MemoryState.readLimbs_storeLimbs_coord (a := 80) (b := 40) hr.storeLimbs.storeLimbs (by omega)
        (by omega) (by omega),
      MemoryState.readLimbs_storeLimbs_self hr.2.2.1.storeLimbs]
  · rw [MemoryState.readLimbs_storeLimbs_coord (a := 120) (b := 80)
        hr.storeLimbs.storeLimbs.storeLimbs (by omega) (by omega) (by omega),
      MemoryState.readLimbs_storeLimbs_self hr.2.2.2.1.storeLimbs.storeLimbs]
  · rw [MemoryState.readLimbs_storeLimbs_self hr.2.2.2.2.storeLimbs.storeLimbs.storeLimbs]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storePt_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storePt p P b).readBase p = b :=
  MemoryState.readBase_storeAt_self (by simpa [MemoryState.PtRoom] using h)

/-! ### Reads of other blocks -/

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_storeAt_of_id_ne {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : q.id ≠ p.id) : (m.storeAt q x).readPt p = m.readPt p := by
  have h' (k : BitVec 64) : q.id ≠ (p.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPt, MemoryState.readLimbs_storeAt_of_id_ne h,
    MemoryState.readLimbs_storeAt_of_id_ne (h' _)]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storeAt_of_id_ne {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : q.id ≠ p.id) : (m.storeAt q x).readBase p = m.readBase p := by
  unfold MemoryState.readBase;
  exact MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (q := p.add 160#64) h) x

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : q.id ≠ p.id) : (m.storeLimbs q l).readPt p = m.readPt p := by
  have h' (k : BitVec 64) : q.id ≠ (p.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPt, MemoryState.readLimbs_storeLimbs_of_id_ne h,
    MemoryState.readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storeLimbs_of_id_ne {m : MemoryState}
    {p q : Pointer} (h : q.id ≠ p.id) : (m.storeLimbs q l).readBase p = m.readBase p := by
  have h' (k : BitVec 64) : (Range.of (q.add k) 64).Disjoint (Range.of (p.add 160#64) 1) :=
    Range.disjoint_of_id_ne (by simpa [Pointer.add_id] using h)
  simp only [MemoryState.readBase, MemoryState.storeLimbs]
  rw [MemoryState.readAt_storeAt_disjoint (h' _), MemoryState.readAt_storeAt_disjoint (h' _),
    MemoryState.readAt_storeAt_disjoint (h' _), MemoryState.readAt_storeAt_disjoint (h' _),
    MemoryState.readAt_storeAt_disjoint (by simpa [Pointer.add_id] using h' 0#64)]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_storePt_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : q.id ≠ p.id) : (m.storePt q Q c).readPt p = m.readPt p := by
  have h' (k : BitVec 64) : (q.add k).id ≠ p.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storePt, MemoryState.readPt_storeAt_of_id_ne (h' _),
    MemoryState.readPt_storeLimbs_of_id_ne (h' _), MemoryState.readPt_storeLimbs_of_id_ne h]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storePt_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : q.id ≠ p.id) : (m.storePt q Q c).readBase p = m.readBase p := by
  have h' (k : BitVec 64) : (q.add k).id ≠ p.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storePt, MemoryState.readBase_storeAt_of_id_ne (h' _),
    MemoryState.readBase_storeLimbs_of_id_ne (h' _), MemoryState.readBase_storeLimbs_of_id_ne h]

/-- Limbs in another block are unaffected by a masked store. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readLimbs_storeDef_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} (h : q.id ≠ p.id) : (m.storeDef q x d).readLimbs p = m.readLimbs p := by
  have h' (k : BitVec 64) : (Range.of q w).Disjoint (Range.of (p.add k) 64) :=
    Range.disjoint_of_id_ne (by simpa [Pointer.add_id] using h)
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs]
  · simpa [Pointer.add_zero] using MemoryState.readAt_storeDef_disjoint (h' 0#64) x d
  all_goals exact MemoryState.readAt_storeDef_disjoint (h' _) x d

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readLimbs_storeCopy_of_id_ne {m : MemoryState}
    {p q : Pointer} {x d : BitVec w} {P : Nat → Option Pointer} (h : q.id ≠ p.id) :
    (m.storeCopy q x d P).readLimbs p = m.readLimbs p := by
  have h' (k : BitVec 64) : (Range.of q w).Disjoint (Range.of (p.add k) 64) :=
    Range.disjoint_of_id_ne (by simpa [Pointer.add_id] using h)
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs]
  · simpa [Pointer.add_zero] using MemoryState.readAt_storeCopy_disjoint (h' 0#64) x d
  all_goals exact MemoryState.readAt_storeCopy_disjoint (h' _) x d

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_storeDef_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} (h : q.id ≠ p.id) : (m.storeDef q x d).readPt p = m.readPt p := by
  have h' (k : BitVec 64) : q.id ≠ (p.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPt, MemoryState.readLimbs_storeDef_of_id_ne h,
    MemoryState.readLimbs_storeDef_of_id_ne (h' _)]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_storeCopy_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} {P : Nat → Option Pointer} (h : q.id ≠ p.id) :
    (m.storeCopy q x d P).readPt p = m.readPt p := by
  have h' (k : BitVec 64) : q.id ≠ (p.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPt, MemoryState.readLimbs_storeCopy_of_id_ne h,
    MemoryState.readLimbs_storeCopy_of_id_ne (h' _)]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storeDef_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} (h : q.id ≠ p.id) : (m.storeDef q x d).readBase p = m.readBase p := by
  unfold MemoryState.readBase;
  exact MemoryState.readAt_storeDef_disjoint (Range.disjoint_of_id_ne (q := p.add 160#64) h) x d

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storeCopy_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} {P : Nat → Option Pointer} (h : q.id ≠ p.id) :
    (m.storeCopy q x d P).readBase p = m.readBase p := by
  unfold MemoryState.readBase;
  exact MemoryState.readAt_storeCopy_disjoint (Range.disjoint_of_id_ne (q := p.add 160#64) h) x d

@[mlir_frame, mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_alloca {s : GlobalState} {p : Pointer}
    (hne : p.id ≠ s.allocaPtr.id) : (s.alloca n d).mem.readPt p = s.mem.readPt p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readPt, MemoryState.readLimbs_alloca hne,
    MemoryState.readLimbs_alloca (hne' _)]

@[mlir_frame, mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_alloca {s : GlobalState} {p : Pointer}
    (hne : p.id ≠ s.allocaPtr.id) : (s.alloca n d).mem.readBase p = s.mem.readBase p := by
  simp only [MemoryState.readBase, MemoryState.readAt, Pointer.add_id,
    GlobalState.getElem?_alloca hne]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_addBlock_of_id_ne {m : MemoryState} {p : Pointer}
    {x : BitVec v} (h : p.id ≠ b) : (m.addBlock b n x).readPt p = m.readPt p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPt, MemoryState.readLimbs_addBlock_of_id_ne h,
    MemoryState.readLimbs_addBlock_of_id_ne (h' _)]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_addBlock_of_id_ne {m : MemoryState} {p : Pointer}
    {x : BitVec v} (h : p.id ≠ b) : (m.addBlock b n x).readBase p = m.readBase p :=
  MemoryState.readAt_addBlock_of_id_ne (by simpa [Pointer.add_id] using h)

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readPt p = m.readPt p := by
  simp only [MemoryState.readPt, MemoryState.readLimbs_lifetimeStart]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readPt p = m.readPt p := by
  simp only [MemoryState.readPt, MemoryState.readLimbs_lifetimeEnd]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readBase p = m.readBase p :=
  MemoryState.readAt_lifetimeStart

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readBase p = m.readBase p :=
  MemoryState.readAt_lifetimeEnd

/-! ### Whole-point copies (`memcpy` of 168 bytes, with the source's definedness and pointers) -/

/-- A coordinate of a copy: the source's. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readLimbs_copy {m : MemoryState} {p q : Pointer}
    {P : Nat → Option Pointer} {a : Nat}
    (hp : m.PtRoom p) (hq : m.PtLive q) (ha : a ≤ 120) (d : BitVec 1344) :
    (m.storeCopy p (m.readAt q 1344) d P).readLimbs (p.add (BitVec.ofNat 64 a)) =
      m.readLimbs (q.add (BitVec.ofNat 64 a)) := by
  have hrd (k : Nat) (hk : k ≤ a + 32) :
    (m.storeCopy p (m.readAt q 1344) d P).readAt (p.add (BitVec.ofNat 64 k)) 64 =
      m.readAt (q.add (BitVec.ofNat 64 k)) 64 :=
    MemoryState.readAt_storeCopy_readAt_add hp.2 hq.2.inBounds
      (p.not_uaddOverflow_of_pt hp.1
        (by
          simp; omega))
      (q.not_uaddOverflow_of_pt hq.1
        (by
          simp; omega))
      (by
        simp; omega)
      d
  have hadd (r : Pointer) (k : Nat) :
    (r.add (BitVec.ofNat 64 a)).add (BitVec.ofNat 64 k) = r.add (BitVec.ofNat 64 (a + k)) := by
    rw [Pointer.add_add, BitVec.ofNat_add]
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs]
  · exact hrd a (by omega)
  · rw [show (8#64 : BitVec 64) = BitVec.ofNat 64 8 from rfl, hadd, hadd]; exact hrd _ (by omega)
  · rw [show (16#64 : BitVec 64) = BitVec.ofNat 64 16 from rfl, hadd, hadd]
    exact hrd _ (by omega)
  · rw [show (24#64 : BitVec 64) = BitVec.ofNat 64 24 from rfl, hadd, hadd]
    exact hrd _ (by omega)
  · rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl, hadd, hadd]
    exact hrd _ (by omega)

/-- `x` of a copy: the source's. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readLimbs_copy_x {m : MemoryState} {p q : Pointer}
    {P : Nat → Option Pointer}
    (hp : m.PtRoom p) (hq : m.PtLive q) (d : BitVec 1344) :
    (m.storeCopy p (m.readAt q 1344) d P).readLimbs p = m.readLimbs q := by
  simpa [Pointer.add_zero'] using MemoryState.readLimbs_copy (a := 0) hp hq (by omega) d

/-- A copy of a point: the source's point. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_copy {m : MemoryState} {p q : Pointer}
    {P : Nat → Option Pointer}
    (hp : m.PtRoom p) (hq : m.PtLive q) (d : BitVec 1344) :
    (m.storeCopy p (m.readAt q 1344) d P).readPt p = m.readPt q := by
  simp only [MemoryState.readPt, MemoryState.readLimbs_copy_x hp hq,
    MemoryState.readLimbs_copy (a := 40) hp hq (by omega),
    MemoryState.readLimbs_copy (a := 80) hp hq (by omega),
    MemoryState.readLimbs_copy (a := 120) hp hq (by omega)]

/-- `is_base` of a copy: the source's. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_copy {m : MemoryState} {p q : Pointer}
    {P : Nat → Option Pointer}
    (hp : m.PtRoom p) (hq : m.PtLive q) (d : BitVec 1344) :
    (m.storeCopy p (m.readAt q 1344) d P).readBase p = m.readBase q :=
  MemoryState.readAt_storeCopy_readAt_add hp.2 hq.2.inBounds
    (p.not_uaddOverflow_of_pt hp.1 (by decide)) (q.not_uaddOverflow_of_pt hq.1 (by decide))
    (by decide) d

/-- A copy of a known point is known. -/
@[mlir_fresh, mlir_mem]
public theorem _root_.MLIR.MemoryState.PtFit.copy {m : MemoryState} {p q : Pointer}
    {P : Nat → Option Pointer}
    (hp : m.PtRoom p) (hq : m.PtFit q) :
    (m.storeCopy p (m.readAt q 1344) (m.definedAt q 1344) P).PtFit p := by
  have hc (k : BitVec 64) (hk : k.toNat ≤ 120) (hf : Fits m (q.add k) 320) :
    Fits (m.storeCopy p (m.readAt q 1344) (m.definedAt q 1344) P) (p.add k) 320 :=
    Fits.storeCopy_definedAt hp.2 hf (p.not_uaddOverflow_of_pt hp.1 (by omega))
      (q.not_uaddOverflow_of_pt hq.1 (by omega)) (by omega)
  have hl (k : BitVec 64) (hk : k.toNat ≤ 120) (hf : m.LimbsFit (q.add k)) :
    (m.storeCopy p (m.readAt q 1344) (m.definedAt q 1344) P).LimbsFit (p.add k) :=
    .of_fits' (hc k hk hf.fits)
      (by
        simp only [Pointer.add, BitVec.toNat_add]; have := hp.1; omega)
  refine
    ⟨hp.1, hp.2.1.storeCopy,
      .of_fits' (Fits.storeCopy_definedAt_self hp.2 hq.2.2.1.fits (by omega))
        (by
          have := hp.1; omega),
      hl _ (by decide) hq.2.2.2.1, hl _ (by decide) hq.2.2.2.2.1, hl _ (by decide) hq.2.2.2.2.2.1,
      ?_⟩
  exact
    Fits.storeCopy_definedAt hp.2 hq.2.2.2.2.2.2 (p.not_uaddOverflow_of_pt hp.1 (by decide))
      (q.not_uaddOverflow_of_pt hq.1 (by decide)) (by decide)

/-- A known point carries no pointer: each 64-bit window of it meets its field elements or
`is_base`. -/
@[mlir_no_ptrs]
public theorem _root_.MLIR.MemoryState.ptrsIn_of_ptFit {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.ptrsIn p 1344 = fun _ => none := by
  have hov (k : BitVec 64) (hk : k.toNat < 168) := p.not_uaddOverflow_of_pt h.1 hk
  refine MemoryState.ptrsIn_eq_none_of_bits fun o ho => ⟨o, le_rfl, by omega, ?_⟩
  by_cases h0 : o < 320
  · exact MemoryState.getLsbD_definedAt_of_fits_self h.2.2.1.fits h0 (by omega)
  by_cases h1 : o < 640
  · exact MemoryState.getLsbD_definedAt_of_fits h.2.2.2.1.fits (hov _ (by decide)) (by simp; omega)
      (by simp; omega) (by omega)
  by_cases h2 : o < 960
  · exact MemoryState.getLsbD_definedAt_of_fits h.2.2.2.2.1.fits (hov _ (by decide))
      (by simp; omega) (by simp; omega) (by omega)
  by_cases h3 : o < 1280
  · exact MemoryState.getLsbD_definedAt_of_fits h.2.2.2.2.2.1.fits (hov _ (by decide))
      (by simp; omega) (by simp; omega) (by omega)
  -- the window at `is_base`
  have : o = 1280 := by omega
  subst this
  exact MemoryState.getLsbD_definedAt_of_fits h.2.2.2.2.2.2 (hov _ (by decide)) (by simp)
    (by simp) (by omega)

/-! ### Fit across steps -/

@[simp, mlir_state]
public theorem _root_.MLIR.MemoryState.ptRoom_storePt_iff {m : MemoryState} :
    (m.storePt q Q c).PtRoom p ↔ m.PtRoom p := by simp [MemoryState.PtRoom, MemoryState.storePt]

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.storeAt {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : m.PtRoom p) : (m.storeAt q x).PtRoom p :=
  ⟨h.1, h.2.storeAt⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.storeDef {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} (h : m.PtRoom p) : (m.storeDef q x d).PtRoom p :=
  ⟨h.1, h.2.storeDef⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.storeCopy {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} {P : Nat → Option Pointer} (h : m.PtRoom p) : (m.storeCopy q x d P).PtRoom p :=
  ⟨h.1, h.2.storeCopy⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.storeLimbs {m : MemoryState} {p q : Pointer}
    (h : m.PtRoom p) : (m.storeLimbs q l).PtRoom p :=
  ⟨h.1, h.2.storeLimbs⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.storePt {m : MemoryState} {p q : Pointer}
    (h : m.PtRoom p) : (m.storePt q Q c).PtRoom p :=
  MemoryState.ptRoom_storePt_iff.mpr h

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.alloca {s : GlobalState} {p : Pointer}
    (hne : p.id ≠ s.allocaPtr.id) (h : s.mem.PtRoom p) : (s.alloca n d).mem.PtRoom p :=
  ⟨h.1, h.2.of_getElem?_eq (GlobalState.getElem?_alloca hne)⟩

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.addBlock {s : GlobalState} {p : Pointer}
    {x : BitVec v} (hwf : s.WF) (h : s.mem.PtRoom p) :
    (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).PtRoom p :=
  ⟨h.1, h.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.lifetimeStart {m : MemoryState} {p q : Pointer}
    (h : m.PtRoom p) (hne : p.id ≠ q.id) : (m.lifetimeStart q).PtRoom p :=
  ⟨h.1, h.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtRoom.lifetimeEnd {m : MemoryState} {p q : Pointer}
    (h : m.PtRoom p) (hne : p.id ≠ q.id) : (m.lifetimeEnd q).PtRoom p :=
  ⟨h.1, h.2.lifetimeEnd hne⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.storeAt {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : m.PtFit p) : (m.storeAt q x).PtFit p :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.1.storeAt,
    h.2.2.2.2.2.1.storeAt, h.2.2.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.storeLimbs {m : MemoryState} {p q : Pointer}
    (h : m.PtFit p) : (m.storeLimbs q l).PtFit p := by
  unfold MemoryState.storeLimbs
  exact h.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.storePt {m : MemoryState} {p q : Pointer}
    (h : m.PtFit p) : (m.storePt q Q c).PtFit p := by
  unfold MemoryState.storePt
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs.storeAt

/-- Limbs in another block stay known across a masked store. -/
@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.LimbsFit.storeDef_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} (hne : q.id ≠ p.id) (h : m.LimbsFit p) : (m.storeDef q x d).LimbsFit p := by
  have hd (k : BitVec 64) : (Range.of q w).Disjoint (Range.of (p.add k) 64) :=
    Range.disjoint_of_id_ne (by simpa [Pointer.add_id] using hne)
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  exact
    ⟨ho, h0.storeDef_of_disjoint (Range.disjoint_of_id_ne hne), h1.storeDef_of_disjoint (hd _),
      h2.storeDef_of_disjoint (hd _), h3.storeDef_of_disjoint (hd _),
      h4.storeDef_of_disjoint (hd _)⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.LimbsFit.storeCopy_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} {P : Nat → Option Pointer} (hne : q.id ≠ p.id) (h : m.LimbsFit p) :
    (m.storeCopy q x d P).LimbsFit p := by
  have hd (k : BitVec 64) : (Range.of q w).Disjoint (Range.of (p.add k) 64) :=
    Range.disjoint_of_id_ne (by simpa [Pointer.add_id] using hne)
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  exact
    ⟨ho, h0.storeCopy_of_disjoint (Range.disjoint_of_id_ne hne), h1.storeCopy_of_disjoint (hd _),
      h2.storeCopy_of_disjoint (hd _), h3.storeCopy_of_disjoint (hd _),
      h4.storeCopy_of_disjoint (hd _)⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.LimbsRoom.storeDef {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} (h : m.LimbsRoom p) : (m.storeDef q x d).LimbsRoom p :=
  ⟨h.1, h.2.1.storeDef, h.2.2.1.storeDef, h.2.2.2.1.storeDef, h.2.2.2.2.1.storeDef,
    h.2.2.2.2.2.storeDef⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.LimbsRoom.storeCopy {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} {P : Nat → Option Pointer} (h : m.LimbsRoom p) :
    (m.storeCopy q x d P).LimbsRoom p :=
  ⟨h.1, h.2.1.storeCopy, h.2.2.1.storeCopy, h.2.2.2.1.storeCopy, h.2.2.2.2.1.storeCopy,
    h.2.2.2.2.2.storeCopy⟩

@[mlir_transport]
public theorem Fe.Lt.storeDef {m : MemoryState} {p q : Pointer} {c : ℕ} {x d : BitVec w}
    (hne : q.id ≠ p.id) (h : Fe.Lt (m.readLimbs p) c) :
    Fe.Lt ((m.storeDef q x d).readLimbs p) c := by rwa [MemoryState.readLimbs_storeDef_of_id_ne hne]

@[mlir_transport]
public theorem Fe.Lt.storeCopy {m : MemoryState} {p q : Pointer} {c : ℕ} {x d : BitVec w}
    {P : Nat → Option Pointer} (hne : q.id ≠ p.id) (h : Fe.Lt (m.readLimbs p) c) :
    Fe.Lt ((m.storeCopy q x d P).readLimbs p) c := by
  rwa [MemoryState.readLimbs_storeCopy_of_id_ne hne]

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.storeDef_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} (hne : q.id ≠ p.id) (h : m.PtFit p) : (m.storeDef q x d).PtFit p :=
  ⟨h.1, h.2.1.storeDef, h.2.2.1.storeDef_of_id_ne hne, h.2.2.2.1.storeDef_of_id_ne hne,
    h.2.2.2.2.1.storeDef_of_id_ne hne, h.2.2.2.2.2.1.storeDef_of_id_ne hne,
    h.2.2.2.2.2.2.storeDef_of_disjoint (Range.disjoint_of_id_ne hne)⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.storeCopy_of_id_ne {m : MemoryState} {p q : Pointer}
    {x d : BitVec w} {P : Nat → Option Pointer} (hne : q.id ≠ p.id) (h : m.PtFit p) :
    (m.storeCopy q x d P).PtFit p :=
  ⟨h.1, h.2.1.storeCopy, h.2.2.1.storeCopy_of_id_ne hne, h.2.2.2.1.storeCopy_of_id_ne hne,
    h.2.2.2.2.1.storeCopy_of_id_ne hne, h.2.2.2.2.2.1.storeCopy_of_id_ne hne,
    h.2.2.2.2.2.2.storeCopy_of_disjoint (Range.disjoint_of_id_ne hne)⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.alloca {s : GlobalState} {p : Pointer}
    (hne : p.id ≠ s.allocaPtr.id) (h : s.mem.PtFit p) : (s.alloca n d).mem.PtFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  have hf : ∀ {q : Pointer} {w}, q.id = p.id → Fits s.mem q w → Fits (s.alloca n d).mem q w :=
    fun hq ⟨b, hb, hl, hs, hd⟩ =>
    ⟨b, by
      rw [GlobalState.getElem?_alloca (hq ▸ hne)]; exact hb, hl, hs, hd⟩
  exact
    ⟨h.1, h.2.1.of_getElem?_eq (GlobalState.getElem?_alloca hne), h.2.2.1.alloca hne,
      h.2.2.2.1.alloca (hne' _),
      h.2.2.2.2.1.alloca (hne' _), h.2.2.2.2.2.1.alloca (hne' _), hf rfl h.2.2.2.2.2.2⟩

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.addBlock {s : GlobalState} {p : Pointer} {x : BitVec v}
    (hwf : s.WF) (h : s.mem.PtFit p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).PtFit p :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.1.addBlock hwf, h.2.2.2.2.1.addBlock hwf,
    h.2.2.2.2.2.1.addBlock hwf, h.2.2.2.2.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.lifetimeStart {m : MemoryState} {p q : Pointer}
    (h : m.PtFit p) (hne : p.id ≠ q.id) : (m.lifetimeStart q).PtFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart hne, h.2.2.2.1.lifetimeStart (hne' _),
      h.2.2.2.2.1.lifetimeStart (hne' _), h.2.2.2.2.2.1.lifetimeStart (hne' _),
      h.2.2.2.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.lifetimeEnd {m : MemoryState} {p q : Pointer}
    (h : m.PtFit p) (hne : p.id ≠ q.id) : (m.lifetimeEnd q).PtFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd hne, h.2.2.2.1.lifetimeEnd (hne' _),
      h.2.2.2.2.1.lifetimeEnd (hne' _), h.2.2.2.2.2.1.lifetimeEnd (hne' _),
      h.2.2.2.2.2.2.lifetimeEnd (hne' _)⟩

/-- A point stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
public theorem _root_.MLIR.MemoryState.PtFit.storePt_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storePt p P b).PtFit p := by
  have hX : (m.storeLimbs p P.x).LimbsFit p := .storeLimbs_self h.limbsRoom_x
  have hY : ((m.storeLimbs p P.x).storeLimbs (p.add 40#64) P.y).LimbsFit (p.add 40#64) :=
    .storeLimbs_self h.limbsRoom_y.storeLimbs
  have hZ :
    (((m.storeLimbs p P.x).storeLimbs (p.add 40#64) P.y).storeLimbs (p.add 80#64) P.z).LimbsFit
      (p.add 80#64) :=
    .storeLimbs_self h.limbsRoom_z.storeLimbs.storeLimbs
  have hT :
    ((((m.storeLimbs p P.x).storeLimbs (p.add 40#64) P.y).storeLimbs (p.add 80#64) P.z).storeLimbs
          (p.add 120#64) P.t).LimbsFit
      (p.add 120#64) :=
    .storeLimbs_self h.limbsRoom_t.storeLimbs.storeLimbs.storeLimbs
  exact
    ⟨h.1, (h.storePt (Q := P) (c := b)).2.1, hX.storeLimbs.storeLimbs.storeLimbs.storeAt,
      hY.storeLimbs.storeLimbs.storeAt, hZ.storeLimbs.storeAt, hT.storeAt,
      Fits.storeAt_self h.room_base.storeLimbs.storeLimbs.storeLimbs.storeLimbs⟩

/-! ### States and frames -/

@[simp, mlir_mem]
public theorem _root_.MLIR.GlobalState.WF_storePt {s : GlobalState} :
    ({ s with mem := m.storePt p P b } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storePt]

@[mlir_transport]
public theorem _root_.MLIR.GlobalState.WF.storePt {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storePt p P b } : GlobalState).WF :=
  GlobalState.WF_storePt.mpr h

@[mlir_transport]
public theorem _root_.MLIR.GlobalState.WF.storePt_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storePt p P b⟩ : GlobalState).WF :=
  GlobalState.WF.storePt (s := ⟨a, m⟩) h

@[mlir_frame, mlir_erase]
public theorem _root_.MLIR.MemoryState.eraseFrom_storePt {m : MemoryState} :
    (m.storePt p P b).eraseFrom n = (m.eraseFrom n).storePt p P b := by
  simp [MemoryState.storePt, MemoryState.eraseFrom_storeLimbs, MemoryState.eraseFrom_storeAt]

@[mlir_frame, mlir_erase]
public theorem _root_.MLIR.MemoryState.storePt_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storePt p P b = m.eraseFrom n := by
  simp [MemoryState.storePt, MemoryState.storeLimbs_eraseFrom_of_le,
    MemoryState.storeAt_eraseFrom_of_le, Pointer.add, h]

/-- A point stored into the frame, dropped before the erase moves past it. -/
@[mlir_erase high]
public theorem _root_.MLIR.MemoryState.eraseFrom_storePt_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storePt p P b).eraseFrom n = m.eraseFrom n := by
  rw [MemoryState.eraseFrom_storePt, MemoryState.storePt_eraseFrom_of_le h]

-- last among the transports: the structural ones carry a `PtRoom` fact first
attribute [mlir_transport] MemoryState.PtFit.room

end MLIR.Zig
