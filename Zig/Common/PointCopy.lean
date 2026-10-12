module

public import Zig.Common.Point
import Std.Data.ExtHashMap.Lemmas
import MLIR.Run.Tactic.Memory
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! Points known by their field elements only (`PtLimbsFit`: `fromBytes`' results, whose `is_base`
byte is undefined), and whole-point copies out of fresh temporaries. -/

namespace MLIR.Zig

open Memory

@[expose] public section

/-- Room for the point at `p`, its field elements known; `is_base` may be undefined. -/
abbrev _root_.MLIR.MemoryState.PtLimbsFit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 168 ≤ 2 ^ 64 ∧
    Room m p 1344 ∧
    m.LimbsFit p ∧ m.LimbsFit (p.add 40#64) ∧ m.LimbsFit (p.add 80#64) ∧ m.LimbsFit (p.add 120#64)

attribute [mlir_mem] MemoryState.PtLimbsFit

end

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.limbsFit_x {m : MemoryState} {p : Pointer}
    (h : m.PtLimbsFit p) : m.LimbsFit p :=
  h.2.2.1

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.limbsFit_y {m : MemoryState} {p : Pointer}
    (h : m.PtLimbsFit p) : m.LimbsFit (p.add 40#64) :=
  h.2.2.2.1

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.limbsFit_z {m : MemoryState} {p : Pointer}
    (h : m.PtLimbsFit p) : m.LimbsFit (p.add 80#64) :=
  h.2.2.2.2.1

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.limbsFit_t {m : MemoryState} {p : Pointer}
    (h : m.PtLimbsFit p) : m.LimbsFit (p.add 120#64) :=
  h.2.2.2.2.2

public theorem _root_.MLIR.MemoryState.PtLimbsFit.room {m : MemoryState} {p : Pointer}
    (h : m.PtLimbsFit p) : m.PtRoom p :=
  ⟨h.1, h.2.1⟩

/-- A known point's field elements are known. -/
@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtFit.ptLimbsFit {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) : m.PtLimbsFit p :=
  ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1, h.2.2.2.2.1, h.2.2.2.2.2.1⟩

/-- A copy of a point whose field elements are known has them known. -/
@[mlir_fresh, mlir_mem]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.copy {m : MemoryState} {p q : Pointer}
    (hp : m.PtRoom p) (hq : m.PtLimbsFit q) :
    (m.storeDef p (m.readAt q 1344) (m.definedAt q 1344)).PtLimbsFit p := by
  have hl (k : BitVec 64) (hk : k.toNat ≤ 120) (hf : m.LimbsFit (q.add k)) :
    (m.storeDef p (m.readAt q 1344) (m.definedAt q 1344)).LimbsFit (p.add k) :=
    .of_fits'
      (Fits.storeDef_definedAt hp.2 hf.fits (p.not_uaddOverflow_of_pt hp.1 (by omega))
        (q.not_uaddOverflow_of_pt hq.1 (by omega)) (by omega))
      (by
        simp only [Pointer.add, BitVec.toNat_add]; have := hp.1; omega)
  exact
    ⟨hp.1, hp.2.storeDef,
      .of_fits' (Fits.storeDef_definedAt_self hp.2 hq.2.2.1.fits (by omega))
        (by
          have := hp.1; omega),
      hl _ (by decide) hq.2.2.2.1, hl _ (by decide) hq.2.2.2.2.1, hl _ (by decide) hq.2.2.2.2.2⟩

/-! ### Copies whose source bits the steps read below a frame -/

/-- A coordinate of a copy of the bits `x` read at `q`: `q`'s. -/
public theorem _root_.MLIR.MemoryState.readLimbs_copy_of {m : MemoryState} {p q : Pointer} {a : Nat}
    {x : BitVec 1344} (hp : m.PtRoom p) (hq : m.PtRoom q) (ha : a ≤ 120) (hx : m.readAt q 1344 = x)
    (d : BitVec 1344) :
    (m.storeDef p x d).readLimbs (p.add (BitVec.ofNat 64 a)) =
      m.readLimbs (q.add (BitVec.ofNat 64 a)) := by
  subst hx
  exact MemoryState.readLimbs_copy hp hq ha d

/-- A copy of the bits `x` read at `q`: `q`'s point. -/
public theorem _root_.MLIR.MemoryState.readPt_copy_of {m : MemoryState} {p q : Pointer}
    {x : BitVec 1344} (hp : m.PtRoom p) (hq : m.PtRoom q) (hx : m.readAt q 1344 = x)
    (d : BitVec 1344) : (m.storeDef p x d).readPt p = m.readPt q := by
  subst hx
  exact MemoryState.readPt_copy hp hq d

/-! ### Definedness below a frame -/

/-- Definedness below an `alloca`: as before it. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.definedAt_alloca {s : GlobalState} (hwf : s.WF)
    (h : InBounds s.mem q w) : (s.alloca n d).mem.definedAt q w = s.mem.definedAt q w := by
  simp only [MemoryState.definedAt,
    GlobalState.getElem?_alloca (GlobalState.ne_allocaPtr_of_inBounds hwf h)]

/-- Definedness in another block than a new one's: as before it. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.definedAt_addBlock_of_id_ne {m : MemoryState} {b : BlockId}
    {x : BitVec v} (h : q.id ≠ b) : (m.addBlock b n x).definedAt q w = m.definedAt q w := by
  have hget : (m.addBlock b n x)[q.id]? = m[q.id]? := by
    simp only [MemoryState.addBlock, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_insert]
    split
    · rename_i heq
      exact absurd (beq_iff_eq.mp heq).symm h
    · rfl
  unfold MemoryState.definedAt
  rw [hget]

/-- Definedness in bounds before a new block: as before it. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.definedAt_addBlock {s : GlobalState} {x : BitVec v}
    (hwf : s.WF) (h : InBounds s.mem q w') :
    (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).definedAt q w = s.mem.definedAt q w :=
  MemoryState.definedAt_addBlock_of_id_ne
    (by simpa [GlobalState.allocaPtr] using GlobalState.ne_allocaPtr_of_inBounds hwf h)

attribute [mlir_read] MemoryState.definedAt_storeDef_disjoint

@[mlir_read]
public theorem _root_.MLIR.MemoryState.definedAt_storeAt_disjoint {v w : Nat} {m : MemoryState}
    {p q : Pointer} (h : (Range.of p v).Disjoint (Range.of q w)) (x : BitVec v) :
    (m.storeAt p x).definedAt q w = m.definedAt q w :=
  MemoryState.definedAt_storeDef_disjoint h x _

/-- A point's stores leave other blocks alone. -/
theorem getElem?_storeLimbs_ne {m : MemoryState} {p q : Pointer} (h : q.id ≠ p.id) :
    (m.storeLimbs q l)[p.id]? = m[p.id]? := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h.symm
  simp only [MemoryState.storeLimbs, MemoryState.getElem?_storeAt_ne (h' _),
    MemoryState.getElem?_storeAt_ne h.symm]

theorem getElem?_storePt_ne {m : MemoryState} {p q : Pointer} (h : q.id ≠ p.id) :
    (m.storePt q Q c)[p.id]? = m[p.id]? := by
  have h' (k : BitVec 64) : q.id ≠ p.id → (q.add k).id ≠ p.id := by simp [Pointer.add_id]
  simp only [MemoryState.storePt, MemoryState.getElem?_storeAt_ne (Ne.symm (h' _ h)),
    getElem?_storeLimbs_ne (h' _ h), getElem?_storeLimbs_ne h]

/-- Definedness alike in blocks held alike. -/
public theorem definedAt_congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?) :
    m'.definedAt p w = m.definedAt p w := by
  unfold MemoryState.definedAt; rw [h]

/-- Definedness in another block than a store's: as before it. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.definedAt_storeLimbs_of_id_ne {m : MemoryState}
    {p q : Pointer} (h : q.id ≠ p.id) : (m.storeLimbs q l).definedAt p w = m.definedAt p w :=
  definedAt_congr (getElem?_storeLimbs_ne h)

/-- Limbs from their five reads. -/
public theorem _root_.MLIR.MemoryState.readLimbs_of_reads {m : MemoryState} {p : Pointer}
    {x : Fin 5 → BitVec 64} (h0 : m.readAt p 64 = x 0) (h1 : m.readAt (p.add 8#64) 64 = x 1)
    (h2 : m.readAt (p.add 16#64) 64 = x 2) (h3 : m.readAt (p.add 24#64) 64 = x 3)
    (h4 : m.readAt (p.add 32#64) 64 = x 4) : m.readLimbs p = x := by
  funext i
  fin_cases i
  · exact h0
  · exact h1
  · exact h2
  · exact h3
  · exact h4

/-! ### Whole points read over their stores -/

/-- A read over a store at its start: the bits read before, the stored ones spliced in. -/
public theorem _root_.MLIR.MemoryState.readAt_storeAt_over {m : MemoryState} {p : Pointer}
    (h : InBounds m p v) (hw : w ≤ v) (x : BitVec w) :
    (m.storeAt p x).readAt p v = spliceBits (m.readAt p v) 0 x := by
  have :=
    MemoryState.readAt_add_storeAt (off := 0#64) h (by simp [BitVec.uaddOverflow, p.offset.isLt])
      (by simpa) x
  simpa [Pointer.add_zero'] using this

/-- Definedness over a store inside the range: the stored bits' made defined. -/
public theorem _root_.MLIR.MemoryState.definedAt_add_storeAt {m : MemoryState} {p : Pointer}
    {off : BitVec 64} (h : InBounds m p v) (hov : ¬p.offset.uaddOverflow off)
    (_hw : off.toNat * 8 + w ≤ v) (x : BitVec w) :
    (m.storeAt (p.add off) x).definedAt p v =
      spliceBits (m.definedAt p v) (off.toNat * 8) (BitVec.allOnes w) := by
  obtain ⟨blk, hblk, hsz⟩ := h
  have hs :
    (m.storeAt (p.add off) x)[p.id]? =
      some
        { blk with
          bytes := spliceBits blk.bytes (p.add off).offsetInBits x
          defined := spliceBits blk.defined (p.add off).offsetInBits (BitVec.allOnes w) } :=
    MemoryState.getElem?_storeAt_self (p := p.add off) hblk
  simp only [MemoryState.definedAt, hs, hblk]
  unfold MemoryBlock.lengthInBits at hsz
  rw [Pointer.offsetInBits_add hov]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', getLsbD_spliceBits]
  grind

public theorem _root_.MLIR.MemoryState.definedAt_storeAt_over {m : MemoryState} {p : Pointer}
    (h : InBounds m p v) (hw : w ≤ v) (x : BitVec w) :
    (m.storeAt p x).definedAt p v = spliceBits (m.definedAt p v) 0 (BitVec.allOnes w) := by
  have :=
    MemoryState.definedAt_add_storeAt (off := 0#64) h (by simp [BitVec.uaddOverflow, p.offset.isLt])
      (by simpa) x
  simpa [Pointer.add_zero'] using this

@[expose] public section

/-- `x` with the point `P` and `is_base` `b` stored over it, as `storePt` stores them. -/
def ZPt.over (x : BitVec 1344) (P : ZPt) (b : BitVec 1) : BitVec 1344 :=
  spliceBits
    (spliceBits
      (spliceBits (spliceBits (spliceBits x 0 (limbsBits P.x)) 320 (limbsBits P.y)) 640
        (limbsBits P.z))
      960 (limbsBits P.t))
    1280 b

/-- `d` with `storePt`'s stores made defined. -/
def ZPt.overDef (d : BitVec 1344) : BitVec 1344 :=
  spliceBits
    (spliceBits
      (spliceBits (spliceBits (spliceBits d 0 (BitVec.allOnes 320)) 320 (BitVec.allOnes 320)) 640
        (BitVec.allOnes 320))
      960 (BitVec.allOnes 320))
    1280 (BitVec.allOnes 1)

/-- A fresh slot's bits after `storePt`: the point's, the padding zero. -/
abbrev ZPt.raw (P : ZPt) (b : BitVec 1) : BitVec 1344 :=
  ZPt.over 0 P b

/-- Which of them are defined: all but the padding. -/
abbrev ZPt.rawDef : BitVec 1344 :=
  ZPt.overDef 0

/-- The point `P`, `is_base` `b`, copied whole out of a fresh slot into `p`. -/
abbrev _root_.MLIR.MemoryState.storePtCopy (m : MemoryState) (p : Pointer) (P : ZPt)
    (b : BitVec 1) : MemoryState :=
  m.storeDef p (P.raw b) ZPt.rawDef

end

/-- A point's bits over its stores. -/
public theorem _root_.MLIR.MemoryState.readAt_storePt_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storePt p P b).readAt p 1344 = P.over (m.readAt p 1344) b := by
  have hi : InBounds m p 1344 := h.2.inBounds
  have hf (a : Nat) (ha : a ≤ 120) := Pointer.field_offset h.1 ha
  have hov (k : BitVec 64) (hk : k.toNat < 168) := p.not_uaddOverflow_of_pt h.1 hk
  simp only [MemoryState.storePt]
  rw [MemoryState.storeLimbs_eq_storeAt (p := p) (by simpa using hf 0 (by omega)),
    MemoryState.storeLimbs_eq_storeAt (p := p.add 40#64) (hf 40 (by omega)),
    MemoryState.storeLimbs_eq_storeAt (p := p.add 80#64) (hf 80 (by omega)),
    MemoryState.storeLimbs_eq_storeAt (p := p.add 120#64) (hf 120 (by omega)),
    MemoryState.readAt_add_storeAt hi.storeAt.storeAt.storeAt.storeAt (hov _ (by decide))
      (by decide),
    MemoryState.readAt_add_storeAt hi.storeAt.storeAt.storeAt (hov _ (by decide)) (by decide),
    MemoryState.readAt_add_storeAt hi.storeAt.storeAt (hov _ (by decide)) (by decide),
    MemoryState.readAt_add_storeAt hi.storeAt (hov _ (by decide)) (by decide),
    MemoryState.readAt_storeAt_over hi (by decide)]
  rfl

/-- Which of a point's bits are defined over its stores. -/
public theorem _root_.MLIR.MemoryState.definedAt_storePt_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storePt p P b).definedAt p 1344 = ZPt.overDef (m.definedAt p 1344) := by
  have hi : InBounds m p 1344 := h.2.inBounds
  have hf (a : Nat) (ha : a ≤ 120) := Pointer.field_offset h.1 ha
  have hov (k : BitVec 64) (hk : k.toNat < 168) := p.not_uaddOverflow_of_pt h.1 hk
  simp only [MemoryState.storePt]
  rw [MemoryState.storeLimbs_eq_storeAt (p := p) (by simpa using hf 0 (by omega)),
    MemoryState.storeLimbs_eq_storeAt (p := p.add 40#64) (hf 40 (by omega)),
    MemoryState.storeLimbs_eq_storeAt (p := p.add 80#64) (hf 80 (by omega)),
    MemoryState.storeLimbs_eq_storeAt (p := p.add 120#64) (hf 120 (by omega)),
    MemoryState.definedAt_add_storeAt hi.storeAt.storeAt.storeAt.storeAt (hov _ (by decide))
      (by decide),
    MemoryState.definedAt_add_storeAt hi.storeAt.storeAt.storeAt (hov _ (by decide)) (by decide),
    MemoryState.definedAt_add_storeAt hi.storeAt.storeAt (hov _ (by decide)) (by decide),
    MemoryState.definedAt_add_storeAt hi.storeAt (hov _ (by decide)) (by decide),
    MemoryState.definedAt_storeAt_over hi (by decide)]
  rfl

/-- A fresh slot's bits are zero. -/
public theorem _root_.MLIR.MemoryState.readAt_alloca_allocaPtr {s : GlobalState} {n w : Nat} :
    (s.alloca n d).mem.readAt s.allocaPtr w = 0 := by
  simp [MemoryState.readAt, GlobalState.alloca, GlobalState.allocaPtr, MemoryState.getElem?_eq]

/-- None of a fresh slot's bits are defined. -/
public theorem _root_.MLIR.MemoryState.definedAt_alloca_allocaPtr {s : GlobalState} {n w : Nat} :
    (s.alloca n d).mem.definedAt s.allocaPtr w = 0 := by
  simp [MemoryState.definedAt, GlobalState.alloca, GlobalState.allocaPtr, MemoryState.getElem?_eq]

/-- Bits in another block than a stored point's: as before it. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readAt_storePt_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : q.id ≠ p.id) : (m.storePt q Q c).readAt p w = m.readAt p w :=
  readAt_congr (getElem?_storePt_ne h)

/-- Definedness in another block than a stored point's: as before it. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.definedAt_storePt_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : q.id ≠ p.id) : (m.storePt q Q c).definedAt p w = m.definedAt p w :=
  definedAt_congr (getElem?_storePt_ne h)

/-- The splices' low 1280 bits: the four field elements'. -/
theorem splice4_low (x : BitVec 1344) (X Y Z T : BitVec 320) (b : BitVec 1) :
    (spliceBits (spliceBits (spliceBits (spliceBits (spliceBits x 0 X) 320 Y) 640 Z) 960 T) 1280
            b).extractLsb'
        0 1280 =
      T ++ Z ++ Y ++ X := by
  simp only [spliceBits_eq]
  bv_decide

/-- The defined splices' low 1281 bits: all. -/
theorem splice5_def (d : BitVec 1344) :
    (spliceBits
            (spliceBits
              (spliceBits
                (spliceBits (spliceBits d 0 (BitVec.allOnes 320)) 320 (BitVec.allOnes 320)) 640
                (BitVec.allOnes 320))
              960 (BitVec.allOnes 320))
            1280 (BitVec.allOnes 1)).extractLsb'
        0 1281 =
      BitVec.allOnes 1281 := by
  simp only [spliceBits_eq]
  bv_decide

public theorem ZPt.over_bits (x : BitVec 1344) (P : ZPt) (b : BitVec 1) :
    (P.over x b).extractLsb' 0 1280 = P.bits :=
  splice4_low _ _ _ _ _ _

public theorem ZPt.over_base (x : BitVec 1344) (P : ZPt) (b : BitVec 1) :
    (P.over x b).extractLsb' 1280 1 = b :=
  extractLsb'_spliceBits_self _ _ _ (by decide)

public theorem ZPt.overDef_low (d : BitVec 1344) :
    (ZPt.overDef d).extractLsb' 0 1281 = BitVec.allOnes 1281 :=
  splice5_def d

/-- A point copied out of a fresh slot reads back. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readPt_storePtCopy_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storePtCopy p P b).readPt p = P :=
  MemoryState.readPt_of_readAt (h.2.storeDef.inBounds.mono (by omega)) h.1
    ((MemoryState.readAt_storeDef_le h.2.inBounds (by omega) _ _).trans (ZPt.over_bits _ _ _))

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readBase_storePtCopy_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storePtCopy p P b).readBase p = b :=
  (MemoryState.readAt_storeDef_add h.2.inBounds (p.not_uaddOverflow_of_pt h.1 (by decide))
        (by decide) _ _).trans
    (ZPt.over_base _ _ _)

/-- A point copied out of a fresh slot is known. -/
@[mlir_fresh, mlir_mem]
public theorem _root_.MLIR.MemoryState.PtFit.storePtCopy_self {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) : (m.storePtCopy p P b).PtFit p :=
  .of_fits h.2.storeDef (Fits.storeDef_of_mask_self h.2 (by omega) (ZPt.overDef_low 0)) h.1

/-- A copy out of a slot holding a point as a fresh slot does. -/
public theorem _root_.MLIR.MemoryState.storeDef_copy_eq {m m' : MemoryState} {p q : Pointer}
    (hr : m'.readAt q 1344 = P.raw b) (hd : m'.definedAt q 1344 = ZPt.rawDef) :
    m.storeDef p (m'.readAt q 1344) (m'.definedAt q 1344) = m.storePtCopy p P b := by rw [hr, hd]

/-! ### Known bits from definedness -/

/-- Room whose bits are all defined: known bits. -/
public theorem Fits.of_definedAt {m : MemoryState} {p : Pointer} (hr : Room m p w)
    (hd : m.definedAt p w = BitVec.allOnes w) : Fits m p w := by
  obtain ⟨blk, hblk, hl, hsz⟩ := hr
  refine ⟨blk, hblk, hl, hsz, ?_⟩
  simpa [MemoryState.definedAt, hblk] using hd

/-- Definedness of a narrower range at the same start: the low bits. -/
public theorem _root_.MLIR.MemoryState.definedAt_le {m : MemoryState} {p : Pointer} (hw : w ≤ v) :
    m.definedAt p w = (m.definedAt p v).extractLsb' 0 w := by
  unfold MemoryState.definedAt
  split
  · apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp [hi, show i < v by omega]
  · simp

/-- A point whose field elements' bits are all defined, where there is room for it. -/
public theorem _root_.MLIR.MemoryState.PtLimbsFit.of_definedAt {m : MemoryState} {p : Pointer}
    (h : m.PtRoom p) (hd : (m.definedAt p 1344).extractLsb' 0 1280 = BitVec.allOnes 1280) :
    m.PtLimbsFit p := by
  have hf : Fits m p 1280 :=
    Fits.of_definedAt (h.2.mono (by omega)) ((MemoryState.definedAt_le (by omega)).trans hd)
  have hc (k : BitVec 64) (hk : k.toNat ≤ 120) : m.LimbsFit (p.add k) :=
    .of_fits' (Fits.add_of_le (p.not_uaddOverflow_of_pt h.1 (by omega)) (by omega) hf)
      (by
        simp only [Pointer.add, BitVec.toNat_add]; have := h.1; omega)
  exact
    ⟨h.1, h.2,
      .of_fits' (hf.mono (by omega))
        (by
          have := h.1; omega),
      hc _ (by decide), hc _ (by decide), hc _ (by decide)⟩

/-- A known point's field elements' bits are defined. -/
public theorem _root_.MLIR.MemoryState.PtLimbsFit.definedAt {m : MemoryState} {p : Pointer}
    (h : m.PtLimbsFit p) : (m.definedAt p 1344).extractLsb' 0 1280 = BitVec.allOnes 1280 := by
  have hx := h.2.2.1.fits
  have hy := h.2.2.2.1.fits
  have hz := h.2.2.2.2.1.fits
  have ht := h.2.2.2.2.2.fits
  have hov (k : BitVec 64) (hk : k.toNat ≤ 160) := p.not_uaddOverflow_of_pt h.1 (k := k) (by omega)
  have a1 := Fits.append (hov 40#64 (by decide)) (by decide) rfl hx hy
  have a2 := Fits.append (hov 80#64 (by decide)) (by decide) rfl a1 hz
  have a3 := Fits.append (hov 120#64 (by decide)) (by decide) rfl a2 ht
  rw [← MemoryState.definedAt_le (by omega)]
  exact MemoryState.definedAt_of_fits a3

/-- A copy out of a fresh slot's bits read back: its field elements' bits are defined. -/
public theorem ZPt.rawDef_low : ZPt.rawDef.extractLsb' 0 1280 = BitVec.allOnes 1280 := by
  simp only [ZPt.rawDef, ZPt.overDef, spliceBits_eq]
  bv_decide

/-- A point's 160 bytes of field elements read whole: its bits. -/
public theorem _root_.MLIR.MemoryState.readAt_pt_bits {m : MemoryState} {p : Pointer}
    (h : InBounds m p 1344) (ho : p.offset.toNat + 168 ≤ 2 ^ 64) :
    (m.readAt p 1344).extractLsb' 0 1280 = (m.readPt p).bits := by
  have hr (k : Nat) (hk : k ≤ 152) :
    m.readAt (p.add (BitVec.ofNat 64 k)) 64 = (m.readAt p 1344).extractLsb' (k * 8) 64 := by
    rw [MemoryState.readAt_add_of_readAt h
        (p.not_uaddOverflow_of_pt ho
          (by
            rw [BitVec.toNat_ofNat]; omega))
        (by
          rw [BitVec.toNat_ofNat]; omega)
        rfl,
      BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  simp only [MemoryState.readPt, MemoryState.readLimbs, ZPt.bits, limbsBits, Pointer.add_add,
    BitVec.reduceAdd]
  rw [show m.readAt p 64 = (m.readAt p 1344).extractLsb' 0 64 by simpa using hr 0 (by omega)]
  rw [hr 8 (by omega), hr 16 (by omega), hr 24 (by omega), hr 32 (by omega), hr 40 (by omega),
    hr 48 (by omega), hr 56 (by omega), hr 64 (by omega), hr 72 (by omega), hr 80 (by omega),
    hr 88 (by omega), hr 96 (by omega), hr 104 (by omega), hr 112 (by omega), hr 120 (by omega),
    hr 128 (by omega), hr 136 (by omega), hr 144 (by omega), hr 152 (by omega)]
  generalize m.readAt p 1344 = x
  simp only [Nat.reduceMul]
  bv_decide

/-! ### Slots whose padding is a fresh slot's -/

@[expose] public section

/-- The padding of the point slot at `t` (bits `1281 …`) is zero and undefined, as in a fresh slot:
`storePt` there leaves the slot as a fresh one would hold the point. -/
def _root_.MLIR.MemoryState.PadClear (m : MemoryState) (t : Pointer) : Prop :=
  (m.readAt t 1344).extractLsb' 1281 63 = 0 ∧ (m.definedAt t 1344).extractLsb' 1281 63 = 0

end

/-- Splices over bits whose top 63 are zero: the splices over zero. -/
theorem splice_over_zero (x : BitVec 1344) (X Y Z T : BitVec 320) (b : BitVec 1)
    (h : x.extractLsb' 1281 63 = 0) :
    spliceBits (spliceBits (spliceBits (spliceBits (spliceBits x 0 X) 320 Y) 640 Z) 960 T) 1280 b =
      spliceBits (spliceBits (spliceBits (spliceBits (spliceBits 0 0 X) 320 Y) 640 Z) 960 T) 1280
        b := by
  simp only [spliceBits_eq] at *
  bv_decide

/-- The splices' top 63 bits: those spliced over. -/
theorem splice_over_top (x : BitVec 1344) (X Y Z T : BitVec 320) (b : BitVec 1) :
    (spliceBits (spliceBits (spliceBits (spliceBits (spliceBits x 0 X) 320 Y) 640 Z) 960 T) 1280
            b).extractLsb'
        1281 63 =
      x.extractLsb' 1281 63 := by
  simp only [spliceBits_eq]
  bv_decide

public theorem ZPt.over_eq_raw {x : BitVec 1344} (h : x.extractLsb' 1281 63 = 0) (P : ZPt)
    (b : BitVec 1) : P.over x b = P.raw b :=
  splice_over_zero _ _ _ _ _ _ h

public theorem ZPt.overDef_eq_rawDef {d : BitVec 1344} (h : d.extractLsb' 1281 63 = 0) :
    ZPt.overDef d = ZPt.rawDef :=
  splice_over_zero _ _ _ _ _ _ h

/-- A point stored where the padding is clear: the slot as a fresh one holds the point. -/
public theorem _root_.MLIR.MemoryState.readAt_storePt_padClear {m : MemoryState} {t : Pointer}
    (h : m.PtRoom t) (hc : m.PadClear t) : (m.storePt t P b).readAt t 1344 = P.raw b := by
  rw [MemoryState.readAt_storePt_self h, ZPt.over_eq_raw hc.1]

public theorem _root_.MLIR.MemoryState.definedAt_storePt_padClear {m : MemoryState} {t : Pointer}
    (h : m.PtRoom t) (hc : m.PadClear t) : (m.storePt t P b).definedAt t 1344 = ZPt.rawDef := by
  rw [MemoryState.definedAt_storePt_self h, ZPt.overDef_eq_rawDef hc.2]

/-- A fresh slot's padding is clear. -/
public theorem _root_.MLIR.MemoryState.PadClear.of_fresh {m : MemoryState} {t : Pointer}
    (hz : m.readAt t 1344 = 0) (hzd : m.definedAt t 1344 = 0) : m.PadClear t := by
  simp [MemoryState.PadClear, hz, hzd]

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.storePt_self {m : MemoryState} {t : Pointer}
    (h : m.PtRoom t) (hc : m.PadClear t) : (m.storePt t P b).PadClear t := by
  refine ⟨?_, ?_⟩
  · rw [MemoryState.readAt_storePt_self h]; exact (splice_over_top _ _ _ _ _ _).trans hc.1
  · rw [MemoryState.definedAt_storePt_self h]; exact (splice_over_top _ _ _ _ _ _).trans hc.2

/-- Padding alike in blocks held alike. -/
theorem PadClear.congr {m m' : MemoryState} {t : Pointer} (h : m'[t.id]? = m[t.id]?)
    (hc : m.PadClear t) : m'.PadClear t :=
  ⟨(readAt_congr h).symm ▸ hc.1, (definedAt_congr h).symm ▸ hc.2⟩

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.storePt {m : MemoryState} {t q : Pointer}
    (hne : q.id ≠ t.id) (hc : m.PadClear t) : (m.storePt q Q c).PadClear t :=
  PadClear.congr (getElem?_storePt_ne hne) hc

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.storeLimbs {m : MemoryState} {t q : Pointer}
    (hne : q.id ≠ t.id) (hc : m.PadClear t) : (m.storeLimbs q l).PadClear t :=
  PadClear.congr (getElem?_storeLimbs_ne hne) hc

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.storeDef {m : MemoryState} {t q : Pointer}
    {x d : BitVec w} (hne : q.id ≠ t.id) (hc : m.PadClear t) : (m.storeDef q x d).PadClear t :=
  PadClear.congr (MemoryState.getElem?_storeDef_ne hne.symm) hc

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.storeAt {m : MemoryState} {t q : Pointer}
    {x : BitVec w} (hne : q.id ≠ t.id) (hc : m.PadClear t) : (m.storeAt q x).PadClear t :=
  PadClear.congr (MemoryState.getElem?_storeAt_ne hne.symm) hc

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.alloca {s : GlobalState} {t : Pointer}
    (hne : t.id ≠ s.allocaPtr.id) (hc : s.mem.PadClear t) : (s.alloca n d).mem.PadClear t :=
  PadClear.congr (GlobalState.getElem?_alloca hne) hc

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.addBlock {m : MemoryState} {t : Pointer}
    {x : BitVec v} (hne : t.id ≠ b) (hc : m.PadClear t) : (m.addBlock b n x).PadClear t := by
  refine PadClear.congr ?_ hc
  simp only [MemoryState.addBlock, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_insert]
  split
  · rename_i heq
    exact absurd (beq_iff_eq.mp heq).symm hne
  · rfl

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.lifetimeStart {m : MemoryState} {t q : Pointer}
    (hne : t.id ≠ q.id) (hc : m.PadClear t) : (m.lifetimeStart q).PadClear t :=
  PadClear.congr (MemoryState.getElem?_setLifetime_ne hne) hc

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PadClear.lifetimeEnd {m : MemoryState} {t q : Pointer}
    (hne : t.id ≠ q.id) (hc : m.PadClear t) : (m.lifetimeEnd q).PadClear t :=
  PadClear.congr (MemoryState.getElem?_setLifetime_ne hne) hc

/-! ### Fit across steps -/

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.storeAt {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : m.PtLimbsFit p) : (m.storeAt q x).PtLimbsFit p :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.1.storeAt, h.2.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.storeLimbs {m : MemoryState} {p q : Pointer}
    (h : m.PtLimbsFit p) : (m.storeLimbs q l).PtLimbsFit p := by
  unfold MemoryState.storeLimbs
  exact h.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.storePt {m : MemoryState} {p q : Pointer}
    (h : m.PtLimbsFit p) : (m.storePt q Q c).PtLimbsFit p := by
  unfold MemoryState.storePt
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs.storeAt

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.storeDef_of_id_ne {m : MemoryState}
    {p q : Pointer} {x d : BitVec w} (hne : q.id ≠ p.id) (h : m.PtLimbsFit p) :
    (m.storeDef q x d).PtLimbsFit p :=
  ⟨h.1, h.2.1.storeDef, h.2.2.1.storeDef_of_id_ne hne, h.2.2.2.1.storeDef_of_id_ne hne,
    h.2.2.2.2.1.storeDef_of_id_ne hne, h.2.2.2.2.2.storeDef_of_id_ne hne⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.alloca {s : GlobalState} {p : Pointer}
    (hne : p.id ≠ s.allocaPtr.id) (h : s.mem.PtLimbsFit p) : (s.alloca n d).mem.PtLimbsFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, (MemoryState.PtRoom.alloca hne h.room).2, h.2.2.1.alloca hne, h.2.2.2.1.alloca (hne' _),
      h.2.2.2.2.1.alloca (hne' _), h.2.2.2.2.2.alloca (hne' _)⟩

@[mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.addBlock {s : GlobalState} {p : Pointer}
    {x : BitVec v} (hwf : s.WF) (h : s.mem.PtLimbsFit p) :
    (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).PtLimbsFit p :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.1.addBlock hwf, h.2.2.2.2.1.addBlock hwf,
    h.2.2.2.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.lifetimeStart {m : MemoryState} {p q : Pointer}
    (h : m.PtLimbsFit p) (hne : p.id ≠ q.id) : (m.lifetimeStart q).PtLimbsFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart hne, h.2.2.2.1.lifetimeStart (hne' _),
      h.2.2.2.2.1.lifetimeStart (hne' _), h.2.2.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.PtLimbsFit.lifetimeEnd {m : MemoryState} {p q : Pointer}
    (h : m.PtLimbsFit p) (hne : p.id ≠ q.id) : (m.lifetimeEnd q).PtLimbsFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd hne, h.2.2.2.1.lifetimeEnd (hne' _),
      h.2.2.2.2.1.lifetimeEnd (hne' _), h.2.2.2.2.2.lifetimeEnd (hne' _)⟩

@[mlir_mem, mlir_transport]
public theorem Room.storePt {m : MemoryState} {p q : Pointer} (h : Room m p w) :
    Room (m.storePt q Q c) p w := by
  unfold MemoryState.storePt
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs.storeAt

@[mlir_mem, mlir_transport]
public theorem InBounds.storePt {m : MemoryState} {p q : Pointer} (h : InBounds m p w) :
    InBounds (m.storePt q Q c) p w := by
  unfold MemoryState.storePt
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs.storeAt

@[mlir_mem, mlir_transport]
public theorem Fits.storePt {m : MemoryState} {p q : Pointer} (h : Fits m p w) :
    Fits (m.storePt q Q c) p w := by
  unfold MemoryState.storePt
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs.storeAt

-- last among the transports, as `PtFit.room`
attribute [mlir_transport] MemoryState.PtLimbsFit.room

end MLIR.Zig
