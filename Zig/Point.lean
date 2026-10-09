module

public import Common.LimbsBits
public import Zig.Fe
public import Zig.Memory
import Std.Data.ExtHashMap.Lemmas
import SSA.Projects.RIR.Run.Tactic.Memory
import Std.Tactic.BVDecide

/-! Points as Zig's `Edwards25519` holds them: field elements `x, y, z, t` at byte offsets 0, 40, 80,
120, then 8 bytes whose lowest bit is `is_base`; 168 bytes in all, copied whole. -/

namespace LeanMLIR.RIR.Zig

open Memory

@[expose] public section

/-- A point's field elements. -/
structure ZPt where
  x : Fin 5 → BitVec 64
  y : Fin 5 → BitVec 64
  z : Fin 5 → BitVec 64
  t : Fin 5 → BitVec 64

/-- A point's 168 bytes, `rest` the last 8. -/
def ZPt.bits (P : ZPt) (rest : BitVec 64) : BitVec 1344 :=
  rest ++ limbsBits P.t ++ limbsBits P.z ++ limbsBits P.y ++ limbsBits P.x

/-- The point at `p`. -/
def _root_.LeanMLIR.RIR.MemoryState.readPt (m : MemoryState) (p : Pointer) : ZPt :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- The last 8 bytes at `p`, `is_base` lowest. -/
def _root_.LeanMLIR.RIR.MemoryState.readRest (m : MemoryState) (p : Pointer) : BitVec 64 :=
  m.readAt (p.add 160#64) 64

/-- Store a point and its last 8 bytes at `p`, at once. -/
abbrev _root_.LeanMLIR.RIR.MemoryState.storePt (m : MemoryState) (p : Pointer) (P : ZPt)
    (rest : BitVec 64) : MemoryState :=
  m.storeAt p (P.bits rest)

/-- The point at `p` fits, its offsets not wrapping. -/
abbrev _root_.LeanMLIR.RIR.MemoryState.PtFit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 168 ≤ 2 ^ 64 ∧ Fits m p 1344

/-- `rest` with its lowest bit, `is_base`, replaced. -/
def ZPt.flag (rest : BitVec 64) (b : BitVec 1) : BitVec 64 :=
  (rest &&& ~~~1#64) ||| b.setWidth 64

end

/-- Bit `j` of a point's bytes. -/
theorem ZPt.getLsbD_bits (P : ZPt) (rest : BitVec 64) (j : Nat) :
    (P.bits rest).getLsbD j =
      if j < 320 then (limbsBits P.x).getLsbD j
      else
        if j < 640 then (limbsBits P.y).getLsbD (j - 320)
        else
          if j < 960 then (limbsBits P.z).getLsbD (j - 640)
          else if j < 1280 then (limbsBits P.t).getLsbD (j - 960) else rest.getLsbD (j - 1280) := by
  simp only [ZPt.bits, BitVec.getLsbD_append]
  simp only [Nat.sub_sub, Nat.reduceAdd]
  split_ifs <;>
    first
    | (exfalso; omega)
    | rfl

/-- A second store at the same place, of the same width, overwrites the first. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.storeAt_storeAt_self {m : MemoryState} {p : Pointer}
    {x y : BitVec w} : (m.storeAt p x).storeAt p y = m.storeAt p y := by
  cases hb : m[p.id]? with
  | none => simp [MemoryState.storeAt, hb]
  | some blk =>
    rw [MemoryState.getElem?_eq] at hb
    simp [MemoryState.storeAt, MemoryState.getElem?_eq, hb, insert_insert_self,
      spliceBits_spliceBits_self]

/-- A store inside a range that fits: the range stored whole, the bits spliced in. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.storeAt_add_eq {m : MemoryState} {p : Pointer}
    {off : BitVec 64} (hf : Fits m p v) (hov : ¬p.offset.uaddOverflow off)
    (hw : off.toNat * 8 + w ≤ v) (y : BitVec w) :
    m.storeAt (p.add off) y = m.storeAt p (spliceBits (m.readAt p v) (off.toNat * 8) y) := by
  obtain ⟨blk, hblk, hsz⟩ := hf
  have hblk' : m[(p.add off).id]? = some blk := hblk
  rw [MemoryState.getElem?_eq] at hblk hblk'
  simp only [MemoryState.storeAt, MemoryState.readAt, MemoryState.getElem?_eq, hblk, Pointer.add_id]
  rw [Pointer.offsetInBits_add hov]
  unfold MemoryBlock.lengthInBits at hsz
  congr 3
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [getLsbD_spliceBits, BitVec.getLsbD_extractLsb']
  generalize p.offsetInBits = o at *
  split_ifs <;>
    first
    | (exfalso; omega)
    | rfl
    | (rw [show i - (o + off.toNat * 8) = i - o - off.toNat * 8 by omega])
    |
      (rw [show o + (i - o) = i by omega,
          show decide (i - o < v) = true by
            simp; omega,
          Bool.true_and])

/-- The field element at byte offset `k` of a range read whole: its bits there. -/
theorem readLimbs_of_readAt_add {m : MemoryState} {p : Pointer} {x : BitVec v} {k : Nat}
    (hf : Fits m p v) (ho : p.offset.toNat + k + 40 ≤ 2 ^ 64) (hk : 8 * k + 320 ≤ v)
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

/-- The point's bits, from its fields' and the last 8 bytes' slices of `x`. -/
theorem bits_slices (x : BitVec 1344) :
    ZPt.bits
        ⟨fun i => x.extractLsb' (64 * i.val) 64, fun i => x.extractLsb' (8 * 40 + 64 * i.val) 64,
          fun i => x.extractLsb' (8 * 80 + 64 * i.val) 64, fun i =>
          x.extractLsb' (8 * 120 + 64 * i.val) 64⟩
        (x.extractLsb' 1280 64) =
      x := by
  simp only [ZPt.bits, limbsBits, Fin.isValue, Fin.val_zero, Fin.val_one, Fin.val_two,
    show ((3 : Fin 5) : Nat) = 3 from rfl, show ((4 : Fin 5) : Nat) = 4 from rfl]
  bv_decide

/-- A point that fits, read whole: its fields' and last 8 bytes' bits. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readAt_eq_ptBits {m : MemoryState} {p : Pointer}
    (hf : Fits m p 1344) (ho : p.offset.toNat + 168 ≤ 2 ^ 64) :
    m.readAt p 1344 = (m.readPt p).bits (m.readRest p) := by
  have h0 := readLimbs_of_readAt_add (k := 0) hf (by omega) (by omega) rfl
  have h40 := readLimbs_of_readAt_add (k := 40) hf (by omega) (by omega) rfl
  have h80 := readLimbs_of_readAt_add (k := 80) hf (by omega) (by omega) rfl
  have h120 := readLimbs_of_readAt_add (k := 120) hf (by omega) (by omega) rfl
  have hr :=
    MemoryState.readAt_add_of_readAt (off := 160#64) (w := 64) hf
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by simp) rfl
  simp only [Nat.mul_zero, Nat.zero_add] at h0
  rw [show BitVec.ofNat 64 0 = 0#64 from rfl, Pointer.add_zero] at h0
  simp only [MemoryState.readPt, MemoryState.readRest, h0, h40, h80, h120, hr]
  exact (bits_slices _).symm

/-- A point copied whole (a `memcpy` of 168 bytes): stored as a point. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.storeAt_readAt_eq_storePt {m m' : MemoryState}
    {p q : Pointer} (hq : m'.PtFit q) :
    m.storeAt p (m'.readAt q 1344) = m.storePt p (m'.readPt q) (m'.readRest q) := by
  rw [MemoryState.readAt_eq_ptBits hq.2 hq.1]

/-- The fields' slices of a point's bits. -/
theorem slices_bits (P : ZPt) (rest : BitVec 64) :
    (fun i : Fin 5 => (P.bits rest).extractLsb' (64 * i.val) 64) = P.x ∧
      (fun i : Fin 5 => (P.bits rest).extractLsb' (8 * 40 + 64 * i.val) 64) = P.y ∧
      (fun i : Fin 5 => (P.bits rest).extractLsb' (8 * 80 + 64 * i.val) 64) = P.z ∧
      (fun i : Fin 5 => (P.bits rest).extractLsb' (8 * 120 + 64 * i.val) 64) = P.t ∧
      (P.bits rest).extractLsb' 1280 64 = rest := by
  obtain ⟨x, y, z, t⟩ := P
  rw [Fe.eta5 x, Fe.eta5 y, Fe.eta5 z, Fe.eta5 t]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  rotate_left 4
  · simp only [ZPt.bits]; bv_decide
  all_goals
    funext i
    fin_cases i <;> simp only [ZPt.bits, limbsBits, Fe.mk5, Fin.isValue] <;> bv_decide

/-- A point stored where it fits reads back. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readPt_storePt_self {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) :
    (m.storePt p P rest).readPt p = P ∧ (m.storePt p P rest).readRest p = rest := by
  have hr := MemoryState.readAt_storeAt_self h.2 (P.bits rest)
  obtain ⟨sx, sy, sz, st, sr⟩ := slices_bits P rest
  have h0 := readLimbs_of_readAt_add (k := 0) (Fits.storeAt h.2) (by omega) (by omega) hr
  have h40 := readLimbs_of_readAt_add (k := 40) (Fits.storeAt h.2) (by omega) (by omega) hr
  have h80 := readLimbs_of_readAt_add (k := 80) (Fits.storeAt h.2) (by omega) (by omega) hr
  have h120 := readLimbs_of_readAt_add (k := 120) (Fits.storeAt h.2) (by omega) (by omega) hr
  have hrest :=
    MemoryState.readAt_add_of_readAt (off := 160#64) (w := 64) (Fits.storeAt h.2)
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by simp) hr
  simp only [Nat.mul_zero, Nat.zero_add] at h0
  rw [show BitVec.ofNat 64 0 = 0#64 from rfl, Pointer.add_zero] at h0
  refine ⟨?_, ?_⟩
  · simp only [MemoryState.readPt, MemoryState.storePt] at h0 h40 h80 h120 ⊢
    rw [h0, h40, h80, h120, sx, sy, sz, st]
  · simp only [MemoryState.readRest, MemoryState.storePt] at hrest ⊢
    rw [hrest, show (160#64).toNat * 8 = 1280 from rfl, sr]

/-- The splices the field stores make, as the point's bits. -/
theorem splices_eq (B : BitVec 1344) (x y z t : Fin 5 → BitVec 64) (b : BitVec 1) :
    spliceBits
        (spliceBits
          (spliceBits (spliceBits (spliceBits B 0 (limbsBits x)) 320 (limbsBits y)) 640
            (limbsBits z))
          960 (limbsBits t))
        1280 b =
      ZPt.bits ⟨x, y, z, t⟩ (ZPt.flag (B.extractLsb' 1280 64) b) := by
  rw [Fe.eta5 x, Fe.eta5 y, Fe.eta5 z, Fe.eta5 t]
  simp only [spliceBits_eq, ZPt.bits, ZPt.flag, limbsBits, Fe.mk5, Fin.isValue]
  bv_decide

/-- The field stores a point function ends with: `x, y, z, t`, then `is_base`, as one point store. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.storeAt_fields_eq {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) (x y z t : Fin 5 → BitVec 64) (b : BitVec 1) :
    ((((m.storeAt p (limbsBits x)).storeAt (p.add 40#64) (limbsBits y)).storeAt (p.add 80#64)
                (limbsBits z)).storeAt
            (p.add 120#64) (limbsBits t)).storeAt
        (p.add 160#64) b =
      m.storePt p ⟨x, y, z, t⟩ (ZPt.flag (m.readRest p) b) := by
  have hov (k : Nat) (hk : k < 168) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  have e0 := MemoryState.storeAt_add_eq (off := 0#64) h.2 (hov 0 (by omega)) (by simp) (limbsBits x)
  rw [Pointer.add_zero] at e0
  rw [e0, MemoryState.storeAt_add_eq h.2.storeAt (hov 40 (by omega)) (by simp),
    MemoryState.readAt_storeAt_self h.2, MemoryState.storeAt_storeAt_self,
    MemoryState.storeAt_add_eq h.2.storeAt (hov 80 (by omega)) (by simp),
    MemoryState.readAt_storeAt_self h.2, MemoryState.storeAt_storeAt_self,
    MemoryState.storeAt_add_eq h.2.storeAt (hov 120 (by omega)) (by simp),
    MemoryState.readAt_storeAt_self h.2, MemoryState.storeAt_storeAt_self,
    MemoryState.storeAt_add_eq h.2.storeAt (hov 160 (by omega)) (by simp),
    MemoryState.readAt_storeAt_self h.2, MemoryState.storeAt_storeAt_self]
  have hr : m.readRest p = (m.readAt p 1344).extractLsb' 1280 64 := by
    rw [MemoryState.readRest,
      MemoryState.readAt_add_of_readAt (off := 160#64) (w := 64) h.2 (hov 160 (by omega)) (by simp)
        rfl]
    rfl
  rw [MemoryState.storePt, hr, ← splices_eq]
  rfl

/-- A point copied whole reads back as the source. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readPt_storeAt_readAt {m m' : MemoryState}
    {p q : Pointer} (hq : m'.PtFit q) (hp : m.PtFit p) :
    (m.storeAt p (m'.readAt q 1344)).readPt p = m'.readPt q ∧
      (m.storeAt p (m'.readAt q 1344)).readRest p = m'.readRest q := by
  rw [MemoryState.storeAt_readAt_eq_storePt hq]
  exact MemoryState.readPt_storePt_self hp

/-- A field's offset does not wrap, in a point whose offsets do not. -/
public theorem _root_.LeanMLIR.RIR.Pointer.field_offset {p : Pointer}
    (hp : p.offset.toNat + 168 ≤ 2 ^ 64) {a : Nat} (ha : a ≤ 120) :
    (p.add (BitVec.ofNat 64 a)).offset.toNat + 32 < 2 ^ 64 := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  omega

/-- Each coordinate's limbs are below `B`. -/
@[expose]
public def ZPt.Lt (P : ZPt) (B : ℕ) : Prop :=
  Fe.Lt P.x B ∧ Fe.Lt P.y B ∧ Fe.Lt P.z B ∧ Fe.Lt P.t B

/-- Limbs below `2^52` are below `2^53`. -/
public theorem ZPt.Lt.mono53 {P : ZPt} (h : P.Lt (2 ^ 52)) : P.Lt (2 ^ 53) :=
  ⟨h.1.mono (by decide), h.2.1.mono (by decide), h.2.2.1.mono (by decide), h.2.2.2.mono (by decide)⟩

/-! ### Fit across steps -/

/-- The field element at byte offset `k` of a point that fits. -/
theorem PtFit.limbsFit_add {m : MemoryState} {p : Pointer} (h : m.PtFit p) {k : Nat}
    (hk : k ≤ 120) : m.LimbsFit (p.add (BitVec.ofNat 64 k)) := by
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  refine MemoryState.LimbsFit.of_fits' (Fits.add_of_le hov ?_ h.2) ?_
  · rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega
  · simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]; omega

@[mlir_transport]
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.limbsFit_x {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.LimbsFit p := by
  simpa [Pointer.add_zero] using PtFit.limbsFit_add h (k := 0) (by omega)

@[mlir_transport]
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.limbsFit_y {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.LimbsFit (p.add 40#64) :=
  PtFit.limbsFit_add h (k := 40) (by omega)

@[mlir_transport]
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.limbsFit_z {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.LimbsFit (p.add 80#64) :=
  PtFit.limbsFit_add h (k := 80) (by omega)

@[mlir_transport]
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.limbsFit_t {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.LimbsFit (p.add 120#64) :=
  PtFit.limbsFit_add h (k := 120) (by omega)

/-- The last 8 bytes of a point that fits. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.fits_rest {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : Fits m (p.add 160#64) 64 :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow]; omega)
    (by simp) h.2

@[mlir_mem, mlir_transport]
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.storeAt {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : m.PtFit p) : (m.storeAt q x).PtFit p :=
  ⟨h.1, Fits.storeAt h.2⟩

@[mlir_mem, mlir_transport]
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.storeLimbs {m : MemoryState} {p q : Pointer}
    {l : Fin 5 → BitVec 64} (h : m.PtFit p) : (m.storeLimbs q l).PtFit p :=
  ⟨h.1, Fits.storeLimbs h.2⟩

@[mlir_mem, mlir_transport]
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.alloca {s : GlobalState} {p : Pointer}
    (hwf : s.WF) (h : s.mem.PtFit p) : (s.alloca n).mem.PtFit p :=
  ⟨h.1, Fits.alloca hwf h.2⟩

@[mlir_mem, mlir_transport]
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.addBlock {s : GlobalState} {p : Pointer}
    {x : BitVec v} (hwf : s.WF) (h : s.mem.PtFit p) :
    (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).PtFit p := by
  rw [← GlobalState.alloca_storeAt_allocaPtr]
  exact (h.alloca hwf).storeAt

/-- A point that fits, read after an `alloca`: as before it. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readPt_alloca {s : GlobalState} {p : Pointer}
    (hwf : s.WF) (h : s.mem.PtFit p) : (s.alloca n).mem.readPt p = s.mem.readPt p := by
  have hne := GlobalState.ne_allocaPtr_of_fits hwf h.2
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readPt, MemoryState.readLimbs_alloca hne,
    MemoryState.readLimbs_alloca (hne' _)]

/-- The same for the last 8 bytes. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readRest_alloca {s : GlobalState} {p : Pointer}
    (hwf : s.WF) (h : s.mem.PtFit p) : (s.alloca n).mem.readRest p = s.mem.readRest p :=
  MemoryState.readAt_alloca hwf h.fits_rest

/-- A point in a fresh 168-byte block, from its start. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.of_fits {m : MemoryState} {p : Pointer}
    (h : Fits m p 1344) (ho : p.offset = 0) : m.PtFit p :=
  ⟨by simp [ho], h⟩

@[mlir_read]
public theorem _root_.LeanMLIR.RIR.MemoryState.readPt_storeAt_of_id_ne {m : MemoryState}
    {p q : Pointer} {x : BitVec w} (h : q.id ≠ p.id) : (m.storeAt q x).readPt p = m.readPt p := by
  have h' (k : BitVec 64) : q.id ≠ (p.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPt, MemoryState.readLimbs_storeAt_of_id_ne h,
    MemoryState.readLimbs_storeAt_of_id_ne (h' _)]

@[mlir_read]
public theorem _root_.LeanMLIR.RIR.MemoryState.readRest_storeAt_of_id_ne {m : MemoryState}
    {p q : Pointer} {x : BitVec w} (h : q.id ≠ p.id) :
    (m.storeAt q x).readRest p = m.readRest p := by
  have h' : (Range.of q w).Disjoint (Range.of (p.add 160#64) 64) := by
    simp only [Range.Disjoint, Range.of, Pointer.add]; exact .inl h
  exact MemoryState.readAt_storeAt_disjoint h' x

/-- A copy of `p` at `c`, `c` apart from `p`: both read the same point. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readPt_copy {m : MemoryState} {p c : Pointer}
    {v : BitVec 1344} (hp : (m.storeAt c v).PtFit p) (hc : (m.storeAt c v).PtFit c)
    (hne : c.id ≠ p.id) (hv : m.readAt p 1344 = v) :
    (m.storeAt c v).readPt c = (m.storeAt c v).readPt p := by
  subst hv
  have hp' : m.PtFit p := ⟨hp.1, Fits.storeAt_iff.mp hp.2⟩
  have hc' : m.PtFit c := ⟨hc.1, Fits.storeAt_iff.mp hc.2⟩
  rw [(MemoryState.readPt_storeAt_readAt hp' hc').1, MemoryState.readPt_storeAt_of_id_ne hne]

/-- A point read back from its 168 bytes. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readPt_of_readAt {m : MemoryState} {p : Pointer}
    {P : ZPt} {rest : BitVec 64} (h : m.PtFit p) (hr : m.readAt p 1344 = P.bits rest) :
    m.readPt p = P ∧ m.readRest p = rest := by
  have hm : m = m.storePt p P rest := by
    rw [MemoryState.storePt, ← hr, MemoryState.storeAt_readAt_self h.2]
  rw [hm]
  exact MemoryState.readPt_storePt_self h

end LeanMLIR.RIR.Zig
