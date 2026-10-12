module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.Block
public import Zig.Common.BasePointPc
public import Zig.Edwards25519_add
public import Zig.Edwards25519_sub
public import Zig.Edwards25519_dbl
public import Zig.Edwards25519_slide
public import Zig.Edwards25519_rejectIdentity
public import Zig.Edwards25519_precompute
public import Zig.Mlir.Edwards25519_mulDoubleBasePublic
import Zig.Math.Slide
import Std.Tactic.BVDecide
import Std.Data.ExtHashMap.Lemmas
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Rename
import Mathlib.Tactic.IntervalCases

namespace MLIR.Zig

set_option hygiene false in
/-- Two of a frame's slots differ. -/
local macro "slot_ne" : tactic =>
  `(tactic|
    ( simp only [GlobalState.allocaPtr, GlobalState.alloca, GlobalState.slot, ne_eq,
        BlockId.mk.injEq]
      omega))

set_option hygiene false in
/-- A slot of the frame's `alloca`s, as the `alloca` left it: past the later ones by `hS`. -/
local macro "fresh_slot " ht:ident : tactic =>
  `(tactic|
    ( rw [hS, $ht:ident]
      repeat rw [GlobalState.getElem?_alloca (by slot_ne)]
      simp [GlobalState.alloca, GlobalState.slot, MemoryState.getElem?_eq]))

set_option hygiene false in
/-- The frame's slots' ids apart, or in the frame. -/
local macro "slots" : tactic =>
  `(tactic|
    ( dsimp only
      simp only [ht11, ht12, ht13, ht14, ht15, ht16, ht17, hacc, he2, he1, hpc, hbp, hwk, hidp,
        GlobalState.slot, ne_eq, BlockId.mk.injEq, h3]
      omega))

set_option hygiene false in
/-- The temporaries' room and clear padding, from the slots' facts. -/
local macro "temps_facts" : tactic =>
  `(tactic|
    ( intro u hu
      simp only [Ptrs.temps, List.mem_cons, List.not_mem_nil, or_false] at hu
      rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
      · exact ⟨.of_room hacc_room hacc_off, hcacc⟩
      · exact ⟨.of_room ht11_room ht11_off, hc11⟩
      · exact ⟨.of_room ht12_room ht12_off, hc12⟩
      · exact ⟨.of_room ht13_room ht13_off, hc13⟩
      · exact ⟨.of_room ht14_room ht14_off, hc14⟩
      · exact ⟨.of_room ht15_room ht15_off, hc15⟩
      · exact ⟨.of_room ht16_room ht16_off, hc16⟩
      · exact ⟨.of_room ht17_room ht17_off, hc17⟩))

set_option hygiene false in
/-- `hS` kept reversed as `hck`: later states build on an opaque `S`. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

open Memory

/-! ## Specification -/

@[expose] public section

namespace Edwards25519.mulDoubleBasePublic

/-- The base point's table entry `k`; the identity past its 16. -/
def baseTbl (k : Nat) : ZPt :=
  if h : k < 16 then Edwards25519.basePointPc.pts[k] else Edwards25519.identity

/-- `P2`'s table entry `k`, `precompute(P2, 8)`'s; the identity past its 9. -/
def pcTbl (P2 : ZPt) (k : Nat) : ZPt :=
  if h : k < 9 then (Edwards25519.precompute.spec P2)[k] else Edwards25519.identity

/-- Digit `d` on `Q`: `Q + tbl[d]` for `d > 0`, `Q - tbl[-d]` for `d < 0`, else `Q`. -/
def digitStep (tbl : Nat → ZPt) (d : BitVec 8) (Q : ZPt) : ZPt :=
  if 0 < d.toInt then Edwards25519.add.spec Q (tbl d.toNat)
  else if d.toInt < 0 then Edwards25519.sub.spec Q (tbl (-d).toNat) else Q

/-- Position `i`: `x1`'s digit from the base point's table, then `x2`'s from `tbl`. -/
def posStep (tbl : Nat → ZPt) (x1 x2 : BitVec 256) (i : Nat) (Q : ZPt) : ZPt :=
  digitStep tbl (slide.digit x2 i) (digitStep baseTbl (slide.digit x1 i) Q)

/-- Four doublings. -/
def dbl4 (Q : ZPt) : ZPt :=
  dbl.spec (dbl.spec (dbl.spec (dbl.spec Q)))

/-- The loop from `pos = i` down to `0` on `Q`: each position's digits, then four doublings but
after `0`. -/
def ladder (tbl : Nat → ZPt) (x1 x2 : BitVec 256) : Nat → ZPt → ZPt
  | 0, Q => posStep tbl x1 x2 0 Q
  | i + 1, Q => ladder tbl x1 x2 i (dbl4 (posStep tbl x1 x2 (i + 1) Q))

/-- Blocks a digit's call allocates: `add`'s 38, `sub`'s 47. -/
def digitBlocks (d : BitVec 8) : Nat :=
  if 0 < d.toInt then 38 else if d.toInt < 0 then 47 else 0

/-- Blocks the loop allocates from `pos = i` down: the digits', and four `dbl`s' 28 but after
`0`. -/
def ladderBlocks (x1 x2 : BitVec 256) : Nat → Nat
  | 0 => digitBlocks (slide.digit x1 0) + digitBlocks (slide.digit x2 0)
  | i + 1 =>
    digitBlocks (slide.digit x1 (i + 1)) + digitBlocks (slide.digit x2 (i + 1)) + 112 +
      ladderBlocks x1 x2 i

/-- `x1 B + x2 P2` as the program computes it: `none` (`error.WeakPublicKey`) if `rejectIdentity`
rejects entry `4` of `P2`'s table. With `is_base` (`b`) set, the base point's table is used
instead, unchecked. -/
def spec (x1 : BitVec 256) (b : BitVec 1) (P2 : ZPt) (x2 : BitVec 256) : Option ZPt :=
  if b = 1#1 then some (ladder baseTbl x1 x2 63 identity)
  else
    if rejectIdentity.spec (pcTbl P2 4) = 0#16 then some (ladder (pcTbl P2) x1 x2 63 identity)
    else none

/-- Blocks the function allocates, its callees' included. -/
def blocks (x1 : BitVec 256) (b : BitVec 1) (P2 : ZPt) (x2 : BitVec 256) : Nat :=
  if b = 1#1 then 20 + ladderBlocks x1 x2 63
  else if rejectIdentity.spec (pcTbl P2 4) = 0#16 then 251 + ladderBlocks x1 x2 63 else 245

/-- `error.WeakPublicKey`'s definedness: its code's bits only. -/
def weakDef : BitVec 1408 :=
  (Ty.flattenDef Edwards25519_mulDoubleBasePublic_weak.t
        (ZPt.undef, .value 4, Vector.replicate 6 .poison)).2.cast
    (by decide)

/-- The result stored at `out`: a copy of the `WeakPublicKey` global, or `Q` (copied out of a
fresh slot, `is_base` false) with error code `0`. -/
def store (m : MemoryState) (out : Pointer) : Option ZPt → MemoryState
  | none => m.storeDef out Edwards25519_mulDoubleBasePublic_weak.bits weakDef
  | some Q => (m.storeAt (out.add 168#64) 0#16).storePtCopy out Q 0#1

end Edwards25519.mulDoubleBasePublic

end

/-! ## Proof -/

section Proof

open Edwards25519.mulDoubleBasePublic

namespace Edwards25519_mulDoubleBasePublic

/-! ### Tables and digits -/

/-- Entries `0 … 8` of a table of points at `p`: their field elements known, the points `T k`. -/
def TableAt (m : MemoryState) (p : Pointer) (T : Nat → ZPt) : Prop :=
  ∀ k < 9,
    m.PtLimbsFit (p.add (BitVec.ofNat 64 (k * 168))) ∧
      m.readPt (p.add (BitVec.ofNat 64 (k * 168))) = T k

/-- `slide`'s digits of `x` at `e`. -/
def DigitsAt (m : MemoryState) (e : Pointer) (x : BitVec 256) : Prop :=
  Fits m e 512 ∧ e.offset = 0 ∧ m.readAt e 512 = BitVec.packLanes (Edwards25519.slide.spec x)

/-- Known bits alike in blocks held alike. -/
theorem Fits.congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?) (hf : Fits m p w) :
    Fits m' p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := hf
  exact ⟨b, h.trans hb, hl, hw, hd⟩

/-- Room alike in blocks held alike. -/
theorem Room.congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?) (hf : Room m p w) :
    Room m' p w := by
  obtain ⟨b, hb, hl, hw⟩ := hf
  exact ⟨b, h.trans hb, hl, hw⟩

/-- Field elements alike in blocks held alike. -/
theorem LimbsFit.congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?)
    (hf : m.LimbsFit p) : m'.LimbsFit p :=
  have h' (k : BitVec 64) : m'[(p.add k).id]? = m[(p.add k).id]? := by
    rw [Pointer.add_id]; exact h
  ⟨hf.1, Fits.congr h hf.2.1, Fits.congr (h' _) hf.2.2.1, Fits.congr (h' _) hf.2.2.2.1,
    Fits.congr (h' _) hf.2.2.2.2.1, Fits.congr (h' _) hf.2.2.2.2.2⟩

/-- A point's field elements alike in blocks held alike. -/
theorem PtLimbsFit.congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?)
    (hf : m.PtLimbsFit p) : m'.PtLimbsFit p :=
  have h' (k : BitVec 64) : m'[(p.add k).id]? = m[(p.add k).id]? := by
    rw [Pointer.add_id]; exact h
  ⟨hf.1, Room.congr h hf.2.1, LimbsFit.congr h hf.2.2.1, LimbsFit.congr (h' _) hf.2.2.2.1,
    LimbsFit.congr (h' _) hf.2.2.2.2.1, LimbsFit.congr (h' _) hf.2.2.2.2.2⟩

/-- A point alike in blocks held alike. -/
theorem readPt_congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?) :
    m'.readPt p = m.readPt p := by
  have hl (q : Pointer) (hq : q.id = p.id) : m'.readLimbs q = m.readLimbs q := by
    funext i
    fin_cases i <;> simp only [MemoryState.readLimbs] <;>
      exact
        readAt_congr
          (by
            simp only [Pointer.add_id, hq]; exact h)
  simp only [MemoryState.readPt]
  rw [hl p rfl, hl (p.add 40#64) (Pointer.add_id _ _), hl (p.add 80#64) (Pointer.add_id _ _),
    hl (p.add 120#64) (Pointer.add_id _ _)]

/-- `TableAt` in a memory holding the table's block alike. -/
theorem TableAt.congr {m m' : MemoryState} {p : Pointer} {T : Nat → ZPt} (h : m'[p.id]? = m[p.id]?)
    (hT : TableAt m p T) : TableAt m' p T := fun k hk =>
  have h' :
    m'[(p.add (BitVec.ofNat 64 (k * 168))).id]? = m[(p.add (BitVec.ofNat 64 (k * 168))).id]? := by
    rw [Pointer.add_id]; exact h
  ⟨PtLimbsFit.congr h' (hT k hk).1, (readPt_congr h').trans (hT k hk).2⟩

/-- `TableAt` past a store into another block. -/
theorem TableAt.storeAt {m : MemoryState} {p q : Pointer} {T : Nat → ZPt} (h : TableAt m p T)
    (hne : q.id ≠ p.id) (x : BitVec w) : TableAt (m.storeAt q x) p T :=
  h.congr (MemoryState.getElem?_storeAt_ne hne.symm)

/-- `TableAt` past a masked store into another block. -/
theorem TableAt.storeDef {m : MemoryState} {p q : Pointer} {T : Nat → ZPt} {x d : BitVec w}
    (hne : p.id ≠ q.id) (h : TableAt m p T) : TableAt (m.storeDef q x d) p T :=
  h.congr (MemoryState.getElem?_storeDef_ne hne)

/-- `TableAt` past an `alloca`. -/
theorem TableAt.alloca {s : GlobalState} {p : Pointer} {T : Nat → ZPt} (hne : p.id ≠ s.allocaPtr.id)
    (h : TableAt s.mem p T) : TableAt (s.alloca n d).mem p T :=
  h.congr (GlobalState.getElem?_alloca hne)

/-- `DigitsAt` in a memory holding the digits' block alike. -/
theorem DigitsAt.congr {m m' : MemoryState} {e : Pointer} {x : BitVec 256}
    (h : m'[e.id]? = m[e.id]?) (hD : DigitsAt m e x) : DigitsAt m' e x :=
  ⟨Fits.congr h hD.1, hD.2.1, (readAt_congr h).trans hD.2.2⟩

/-- Digit `j`, read alone. -/
theorem DigitsAt.lane {m : MemoryState} (h : DigitsAt m e x) (hj : j < 64) :
    Fits m (e.add (BitVec.ofNat 64 j)) 8 ∧
      m.readAt (e.add (BitVec.ofNat 64 j)) 8 = Edwards25519.slide.digit x j := by
  obtain ⟨hf, ho, hr⟩ := h
  have hj' : (BitVec.ofNat 64 j).toNat = j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have hov : ¬e.offset.uaddOverflow (BitVec.ofNat 64 j) := by
    simp only [BitVec.uaddOverflow, ho, hj', decide_eq_true_eq,
      show (0 : BitVec 64).toNat = 0 from rfl]
    omega
  refine
    ⟨Fits.add_of_le hov
        (by
          rw [hj']; omega)
        hf,
      ?_⟩
  rw [MemoryState.readAt_add_of_readAt hf.inBounds hov
      (by
        rw [hj']; omega)
      hr,
    hj', BitVec.extractLsb'_packLanes _ _ hj]
  simp [Edwards25519.slide.spec]

/-- Entries `0 … 8` known, from their facts at literal offsets. -/
theorem fits_entries {m : MemoryState} {p : Pointer} (h0 : Fits m p 1281)
    (h1 : Fits m (p.add 168#64) 1281) (h2 : Fits m (p.add 336#64) 1281)
    (h3 : Fits m (p.add 504#64) 1281) (h4 : Fits m (p.add 672#64) 1281)
    (h5 : Fits m (p.add 840#64) 1281) (h6 : Fits m (p.add 1008#64) 1281)
    (h7 : Fits m (p.add 1176#64) 1281) (h8 : Fits m (p.add 1344#64) 1281) :
    ∀ k < 9, Fits m (p.add (BitVec.ofNat 64 (k * 168))) 1281 := by
  intro k hk
  interval_cases k
  · simpa [Pointer.add_zero'] using h0
  · simpa using h1
  · simpa using h2
  · simpa using h3
  · simpa using h4
  · simpa using h5
  · simpa using h6
  · simpa using h7
  · simpa using h8

/-- The base point's table global's block (`step_addressof`'s facts): `TableAt`. -/
theorem tableAt_base {m : MemoryState} {p : Pointer} (hr : Room m p 21504) (ho : p.offset = 0)
    (h : m.readAt p 21504 = Edwards25519.basePointPc.bits)
    (hf : ∀ k < 9, Fits m (p.add (BitVec.ofNat 64 (k * 168))) 1281) : TableAt m p baseTbl :=
  fun k hk => by
  obtain ⟨h1, h2, -⟩ := MemoryState.basePointPc_of_readAt hr ho h ⟨k, by omega⟩ (hf k hk)
  refine ⟨h1.ptLimbsFit, h2.trans ?_⟩
  simp [baseTbl, show k < 16 by omega]

/-- Definedness inside a masked store: the stored mask's bits. -/
theorem definedAt_storeDef_add {m : MemoryState} {p : Pointer} {off : BitVec 64}
    (hi : InBounds m p v) (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + w ≤ v)
    (x d : BitVec v) :
    (m.storeDef p x d).definedAt (p.add off) w = d.extractLsb' (off.toNat * 8) w :=
  MemoryState.definedAt_add_of_definedAt hi.storeDef hov hw
    (MemoryState.definedAt_storeDef_self hi _ _)

/-- Entry `k`'s offset in a table at a block's start: no wrap. -/
theorem entry_ov {c : Pointer} (ho : c.offset = 0) (hk : k < 16) :
    (BitVec.ofNat 64 (k * 168)).toNat = k * 168 ∧
      ¬c.offset.uaddOverflow (BitVec.ofNat 64 (k * 168)) := by
  have hk' : (BitVec.ofNat 64 (k * 168)).toNat = k * 168 := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨hk', ?_⟩
  simp only [BitVec.uaddOverflow, ho, hk', decide_eq_true_eq,
    show (0 : BitVec 64).toNat = 0 from rfl]
  omega

/-- `precompute`'s table's lane `k`. -/
theorem pc_bits_lane {P : ZPt} {R : BitVec 1344} (hk : k < 9) :
    (Edwards25519.precompute.bits P R).extractLsb' (k * 1344) 1344 =
      if k = 0 then Edwards25519.identityBits
      else if k = 1 then R else (Edwards25519.precompute.spec P)[k].raw 0 := by
  rw [Edwards25519.precompute.bits, BitVec.extractLsb'_packLanes _ _ hk]
  simp

/-- Its definedness. -/
theorem pc_defs_lane {D : BitVec 1344} (hk : k < 9) :
    (Edwards25519.precompute.defs D).extractLsb' (k * 1344) 1344 =
      if k = 0 then Edwards25519.identityDef else if k = 1 then D else ZPt.rawDef := by
  rw [Edwards25519.precompute.defs, BitVec.extractLsb'_packLanes _ _ hk]
  simp

/-- `precompute`'s table at `c`: `TableAt`, its entries those of `P2`'s table. -/
theorem tableAt_pc {m : MemoryState} {c : Pointer} (hr : Room m c 12096) (ho : c.offset = 0)
    {P : ZPt} {R D : BitVec 1344} (hR : R.extractLsb' 0 1280 = P.bits)
    (hD : D.extractLsb' 0 1280 = BitVec.allOnes 1280) :
    TableAt (m.storeDef c (Edwards25519.precompute.bits P R) (Edwards25519.precompute.defs D)) c
      (pcTbl P) :=
  fun k hk => by
  obtain ⟨hk', hov⟩ := entry_ov ho (k := k) (by omega)
  have hw : (BitVec.ofNat 64 (k * 168)).toNat * 8 + 1344 ≤ 12096 := by
    rw [hk']; omega
  have e8 : (BitVec.ofNat 64 (k * 168)).toNat * 8 = k * 1344 := by
    rw [hk']; omega
  have hb :=
    (MemoryState.readAt_storeDef_add (x := Edwards25519.precompute.bits P R) (d :=
          Edwards25519.precompute.defs D) hr.inBounds hov hw).trans
      (by rw [e8, pc_bits_lane hk])
  have hd :=
    (definedAt_storeDef_add (x := Edwards25519.precompute.bits P R) (d :=
          Edwards25519.precompute.defs D) hr.inBounds hov hw).trans
      (by rw [e8, pc_defs_lane hk])
  have hpr :
    (m.storeDef c (Edwards25519.precompute.bits P R) (Edwards25519.precompute.defs D)).PtRoom
      (c.add (BitVec.ofNat 64 (k * 168))) :=
    ⟨by
      simp only [Pointer.add, ho]
      rw [show (0 : BitVec 64) + BitVec.ofNat 64 (k * 168) = BitVec.ofNat 64 (k * 168) by simp, hk']
      omega, Room.add_of_le hov hw hr.storeDef⟩
  refine
    ⟨.of_definedAt hpr ?_,
      MemoryState.readPt_of_readAt (hpr.2.inBounds.mono (by omega)) hpr.1
        ((MemoryState.readAt_of_readAt_le (by omega) hb).trans ?_)⟩
  · rw [hd]
    split
    · exact identityDef_low
    · split
      · exact hD
      · exact ZPt.rawDef_low
  · rw [BitVec.setWidth_eq_extractLsb' (by omega)]
    simp only [pcTbl, hk, dite_true]
    split
    · rename_i h0; subst h0; exact identityBits_low
    · split
      · rename_i h1; subst h1; exact hR
      · exact ZPt.over_bits _ _ _

/-! ### The loop's objects -/

/-- The function's objects: temporaries `t11 … t17` and the accumulator `acc`, the digits of `s2`
(`e2`) and `s1` (`e1`), the base point's table (`bp`) and `p2`'s (`tb`). -/
structure Ptrs where
  t11 : Pointer
  t12 : Pointer
  t13 : Pointer
  t14 : Pointer
  t15 : Pointer
  t16 : Pointer
  t17 : Pointer
  acc : Pointer
  e2 : Pointer
  e1 : Pointer
  bp : Pointer
  tb : Pointer

/-- The temporaries the calls write. -/
def Ptrs.temps (P : Ptrs) : List Pointer :=
  [P.t11, P.t12, P.t13, P.t14, P.t15, P.t16, P.t17]

/-- The registers the loop reads, `pos` aside. -/
abbrev Regs (P : Ptrs) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) : Prop :=
  E ⊨ [%3484 := P.bp, %3485 := 0#16, %3489 := 168#64, %3491 := 0#64, %3492 := 0#8, %3493 :=
    18446744073709551615#64, %3494 := P.t11, %3495 := P.t12, %3496 := P.t13, %3497 := P.t14,
    %3498 := P.t15, %3499 := P.t16, %3500 := P.t17, %3501 := P.acc, %3502 := P.e2, %3503 := P.e1,
    %3507 := P.tb]

/-- The function's arguments. -/
abbrev Args (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (out s1 p2 s2 : Pointer) : Prop :=
  E.args =
    (Edwards25519_mulDoubleBasePublic.args (.value out) (.value s1) (.value p2) (.value s2)).get

/-- A slot holding `A` as a fresh one would after `storePt … 0`: its bits and definedness. -/
def Holds (m : MemoryState) (t : Pointer) (A : ZPt) : Prop :=
  m.readAt t 1344 = A.raw 0 ∧ m.definedAt t 1344 = ZPt.rawDef

/-- The temporaries: slots in the frame from `N`, at offset `0`, apart from each other and from the
digits and tables. -/
structure Layout (P : Ptrs) (N : Nat) : Prop where
  temp :
    ∀ u ∈ P.acc :: P.temps,
      u.offset = 0 ∧ N ≤ u.id.id ∧ u.id ≠ P.e1.id ∧ u.id ≠ P.e2.id ∧ u.id ≠ P.bp.id ∧ u.id ≠ P.tb.id
  acc_ne : ∀ u ∈ P.temps, u.id ≠ P.acc.id
  bpo : P.bp.offset.toNat + 1512 ≤ 2 ^ 64
  tbo : P.tb.offset.toNat + 1512 ≤ 2 ^ 64

/-- What the loop needs of a state: the digits' and tables' blocks as `M` holds them, room in the
temporaries and the accumulator, their padding a fresh slot's. -/
structure Facts (P : Ptrs) (M : MemoryState) (S : GlobalState) : Prop where
  wf : S.WF
  e1 : S.mem[P.e1.id]? = M[P.e1.id]?
  e2 : S.mem[P.e2.id]? = M[P.e2.id]?
  bp : S.mem[P.bp.id]? = M[P.bp.id]?
  tb : S.mem[P.tb.id]? = M[P.tb.id]?
  temps : ∀ u ∈ P.temps, S.mem.PtRoom u ∧ S.mem.PadClear u
  acc : S.mem.PtRoom P.acc ∧ S.mem.PadClear P.acc

/-- A slot holding `A`: its field elements known, the point `A`. -/
theorem Holds.pt {m : MemoryState} {t : Pointer} {A : ZPt} (hr : m.PtRoom t) (h : Holds m t A) :
    m.PtLimbsFit t ∧ m.readPt t = A :=
  ⟨.of_definedAt hr
      (by
        rw [h.2]; exact ZPt.rawDef_low),
    MemoryState.readPt_of_readAt (hr.2.inBounds.mono (by omega)) hr.1
      ((MemoryState.readAt_of_readAt_le (by omega) h.1).trans
        (by
          rw [BitVec.setWidth_eq_extractLsb' (by omega)]; exact ZPt.over_bits _ _ _))⟩

/-- A slot holding a point: its padding is clear. -/
theorem Holds.padClear {m : MemoryState} {t : Pointer} {A : ZPt} (h : Holds m t A) :
    m.PadClear t := by
  refine ⟨?_, ?_⟩
  · rw [h.1]; simp only [ZPt.raw, ZPt.over, spliceBits_eq]; generalize limbsBits A.x = a
    generalize limbsBits A.y = b; generalize limbsBits A.z = c; generalize limbsBits A.t = d
    bv_decide
  · rw [h.2]; simp only [ZPt.rawDef, ZPt.overDef, spliceBits_eq]; bv_decide

/-- Slots at offset `0` with one id are one. -/
theorem eq_of_id {u v : Pointer} (hu : u.offset = 0) (hv : v.offset = 0) (h : u.id = v.id) :
    u = v := by
  obtain ⟨ui, uo⟩ := u
  obtain ⟨vi, vo⟩ := v
  simp only at h hu hv
  subst h hu hv
  rfl

/-- A `WF` state stays so with its counter advanced. -/
theorem wf_bump {s : GlobalState} (h : s.WF) (hn : s.alloc.nextFreeBlock ≤ n) :
    (⟨⟨n⟩, s.mem⟩ : GlobalState).WF :=
  ⟨fun k hk => Nat.lt_of_lt_of_le (h.bound k hk) hn, Nat.lt_of_lt_of_le h.pos hn, h.null⟩

/-- A point's stores leave other blocks alone. -/
theorem getElem?_storePt_ne' {m : MemoryState} {p q : Pointer} (h : q.id ≠ p.id) :
    (m.storePt q Q c)[p.id]? = m[p.id]? := by
  simp (disch := (simp only [Pointer.add_id]; exact h.symm)) only [MemoryState.storePt,
    MemoryState.storeLimbs, MemoryState.getElem?_storeAt_ne]
  exact MemoryState.getElem?_storeAt_ne h.symm

/-- The facts past a store into `t`, the accumulator or a temporary: the other blocks held alike,
room carried, `t`'s padding clear after. -/
theorem Facts.of_store {P : Ptrs} {M : MemoryState} {S S' : GlobalState} (hF : Facts P M S)
    (hL : Layout P N) (ht : t ∈ P.acc :: P.temps) (hwf : S'.WF)
    (hsame : ∀ q : Pointer, q.id ≠ t.id → S'.mem[q.id]? = S.mem[q.id]?)
    (hroom : ∀ q w, Room S.mem q w → Room S'.mem q w) (hpad : S'.mem.PadClear t) :
    Facts P M S' := by
  have hne (q : Pointer) (h : q.id ≠ t.id) := hsame q h
  have hpc (u : Pointer) (hu : u ∈ P.acc :: P.temps) (hc : S.mem.PadClear u) :
    S'.mem.PadClear u := by
    by_cases h : u.id = t.id
    · rw [eq_of_id (hL.temp u hu).1 (hL.temp t ht).1 h]; exact hpad
    · exact ⟨(readAt_congr (hsame u h)).symm ▸ hc.1, (definedAt_congr (hsame u h)).symm ▸ hc.2⟩
  refine
    ⟨hwf, (hne P.e1 ?_).trans hF.e1, (hne P.e2 ?_).trans hF.e2, (hne P.bp ?_).trans hF.bp,
      (hne P.tb ?_).trans hF.tb, fun u hu => ?_, ?_⟩
  · exact ((hL.temp t ht).2.2.1).symm
  · exact ((hL.temp t ht).2.2.2.1).symm
  · exact ((hL.temp t ht).2.2.2.2.1).symm
  · exact ((hL.temp t ht).2.2.2.2.2).symm
  · obtain ⟨⟨ho, hr⟩, hc⟩ := hF.temps u hu
    exact ⟨⟨ho, hroom _ _ hr⟩, hpc u (List.mem_cons_of_mem _ hu) hc⟩
  · exact ⟨⟨hF.acc.1.1, hroom _ _ hF.acc.1.2⟩, hpc _ List.mem_cons_self hF.acc.2⟩

/-- A temporary's id differs from the accumulator's. -/
theorem Layout.ne_acc (hL : Layout P N) (ht : t ∈ P.temps) : P.acc.id ≠ t.id :=
  (hL.acc_ne t ht).symm

/-- A point a call stores at a temporary `t`: the facts carried, `t` holding it, the accumulator
held alike. -/
theorem Facts.storePt {P : Ptrs} {M : MemoryState} {S : GlobalState} (hF : Facts P M S)
    (hL : Layout P N) (ht : t ∈ P.temps) (hn : S.alloc.nextFreeBlock ≤ n) (A : ZPt) :
    Facts P M ⟨⟨n⟩, S.mem.storePt t A 0#1⟩ ∧
      Holds (S.mem.storePt t A 0#1) t A ∧
      (S.mem.storePt t A 0#1)[P.acc.id]? = S.mem[P.acc.id]? := by
  obtain ⟨⟨ho, hr⟩, hc⟩ := hF.temps t ht
  exact
    ⟨hF.of_store hL (List.mem_cons_of_mem _ ht) (GlobalState.WF.storePt_mk (wf_bump hF.wf hn))
        (fun _ hq => getElem?_storePt_ne' hq.symm) (fun _ _ h => Room.storePt h)
        (MemoryState.PadClear.storePt_self ⟨ho, hr⟩ hc),
      ⟨MemoryState.readAt_storePt_padClear ⟨ho, hr⟩ hc,
        MemoryState.definedAt_storePt_padClear ⟨ho, hr⟩ hc⟩,
      getElem?_storePt_ne' (hL.ne_acc ht).symm⟩

/-- A point a call copies whole into a temporary `t` out of a fresh slot. -/
theorem Facts.storePtCopy {P : Ptrs} {M : MemoryState} {S : GlobalState} (hF : Facts P M S)
    (hL : Layout P N) (ht : t ∈ P.temps) (hn : S.alloc.nextFreeBlock ≤ n) (A : ZPt) :
    Facts P M ⟨⟨n⟩, S.mem.storePtCopy t A 0#1⟩ ∧
      Holds (S.mem.storePtCopy t A 0#1) t A ∧
      (S.mem.storePtCopy t A 0#1)[P.acc.id]? = S.mem[P.acc.id]? := by
  have hr := (hF.temps t ht).1.2
  have hH : Holds (S.mem.storePtCopy t A 0#1) t A :=
    ⟨MemoryState.readAt_storeDef_self hr.inBounds _ _,
      MemoryState.definedAt_storeDef_self hr.inBounds _ _⟩
  exact
    ⟨hF.of_store hL (List.mem_cons_of_mem _ ht) (GlobalState.WF.storeDef_mk (wf_bump hF.wf hn))
        (fun _ hq => MemoryState.getElem?_storeDef_ne hq) (fun _ _ h => Room.storeDef h)
        hH.padClear,
      hH, MemoryState.getElem?_storeDef_ne (hL.ne_acc ht)⟩

/-- A temporary holding `A` copied to the accumulator. -/
theorem Facts.copy {P : Ptrs} {M : MemoryState} {S : GlobalState} (hF : Facts P M S)
    (hL : Layout P N) (hA : Holds S.mem t A) :
    Facts P M ⟨S.alloc, S.mem.storeDef P.acc (S.mem.readAt t 1344) (S.mem.definedAt t 1344)⟩ ∧
      Holds (S.mem.storeDef P.acc (S.mem.readAt t 1344) (S.mem.definedAt t 1344)) P.acc A := by
  have hH : Holds (S.mem.storeDef P.acc (S.mem.readAt t 1344) (S.mem.definedAt t 1344)) P.acc A :=
    ⟨(MemoryState.readAt_storeDef_self hF.acc.1.2.inBounds _ _).trans hA.1,
      (MemoryState.definedAt_storeDef_self hF.acc.1.2.inBounds _ _).trans hA.2⟩
  exact
    ⟨hF.of_store hL (List.mem_cons_self) (GlobalState.WF.storeDef_mk hF.wf)
        (fun _ hq => MemoryState.getElem?_storeDef_ne hq) (fun _ _ h => Room.storeDef h)
        hH.padClear,
      hH⟩

/-- A point a call stores at the accumulator. -/
theorem Facts.storePt_acc {P : Ptrs} {M : MemoryState} {S : GlobalState} (hF : Facts P M S)
    (hL : Layout P N) (hn : S.alloc.nextFreeBlock ≤ n) (A : ZPt) :
    Facts P M ⟨⟨n⟩, S.mem.storePt P.acc A 0#1⟩ ∧ Holds (S.mem.storePt P.acc A 0#1) P.acc A :=
  ⟨hF.of_store hL (List.mem_cons_self) (GlobalState.WF.storePt_mk (wf_bump hF.wf hn))
      (fun _ hq => getElem?_storePt_ne' hq.symm) (fun _ _ h => Room.storePt h)
      (MemoryState.PadClear.storePt_self hF.acc.1 hF.acc.2),
    MemoryState.readAt_storePt_padClear hF.acc.1 hF.acc.2,
    MemoryState.definedAt_storePt_padClear hF.acc.1 hF.acc.2⟩

/-- Entry `k`'s offset in a nine-entry table: no wrap. -/
theorem entry_nov {p : Pointer} (h : p.offset.toNat + 1512 ≤ 2 ^ 64) (hk : k ≤ 8) :
    ¬p.offset.uaddOverflow (BitVec.ofNat 64 (k * 168)) = true := by
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- `sub`'s `call_eq` on the points `P`, `Q` read at `p`, `q`. -/
theorem Edwards25519_sub.call_eq_of (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtRoom out) (hp : s.mem.PtLimbsFit p) (hq : s.mem.PtLimbsFit q)
    (hPd : s.mem.readPt p = P) (hQd : s.mem.readPt q = Q) (hP : P.Lt (2 ^ 53))
    (hQ : Q.Lt (2 ^ 53)) :
    Edwards25519_sub.call (Edwards25519_sub.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 47⟩,
            mem := s.mem.storePtCopy out (Edwards25519.sub.spec P Q) 0#1 }) := by
  subst hPd hQd
  exact Edwards25519_sub.call_eq out p q s hwf hout hp hq hP hQ

/-- A positive digit, `d ≤ 8`. -/
theorem digit_pos {d : BitVec 8} (h1 : (0#8).slt d = true) (h2 : d.toInt ≤ 8) :
    0 < d.toInt ∧ d.toNat ≤ 8 ∧ d.msb = false := by
  revert d; decide

/-- A negative digit, `-8 ≤ d`: `0 - d` does not overflow, and is `|d|`. -/
theorem digit_neg {d : BitVec 8} (h1 : d.slt 0#8 = true) (h2 : -8 ≤ d.toInt) :
    d.toInt < 0 ∧
      ¬0 < d.toInt ∧
      (0#8).ssubOverflow d = false ∧ 0#8 - d = -d ∧ (-d).toNat ≤ 8 ∧ (-d).msb = false := by
  revert d; decide

/-- A digit neither positive nor negative. -/
theorem digit_zero {d : BitVec 8} (h1 : ¬(0#8).slt d = true) (h2 : ¬d.slt 0#8 = true) :
    ¬0 < d.toInt ∧ ¬d.toInt < 0 := by
  revert d; decide

-- two branches, each a call and a copy, the loop's facts carried
set_option maxHeartbeats 1000000 in
/-- `^bb5`: `s1`'s digit at `pos = i` on the accumulator; on to `^bb7`. -/
theorem digit1_block (P : Ptrs) (N : Nat) (hL : Layout P N) (M : MemoryState) (x1 : BitVec 256)
    (hD1 : DigitsAt M P.e1 x1) (hT1 : TableAt M P.bp baseTbl)
    (hTl : ∀ k < 9, (baseTbl k).Lt (2 ^ 53)) (out s1 p2 s2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 64)
    (hd : -8 ≤ (Edwards25519.slide.digit x1 i).toInt ∧ (Edwards25519.slide.digit x1 i).toInt ≤ 8)
    (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : Regs P E) (hRi : E ⊨ [%3511 := BitVec.ofNat 64 i])
    (hF : Facts P M S) (hQd : Holds S.mem P.acc Q)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        Args E' out s1 p2 s2 →
          Regs P E' →
          (E' ⊨ [%3511 := BitVec.ofNat 64 i]) →
          Facts P M S' →
          Holds S'.mem P.acc (digitStep baseTbl (Edwards25519.slide.digit x1 i) Q) →
          S'.alloc.nextFreeBlock =
            S.alloc.nextFreeBlock + digitBlocks (Edwards25519.slide.digit x1 i) →
          S'.mem.eraseFrom N = S.mem.eraseFrom N →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb7 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb5 S >>= g) = K := by
  obtain ⟨hf1, hl1⟩ := (hD1.congr hF.e1).lane hi
  generalize Edwards25519.slide.digit x1 i = d at hd hl1 hK
  dsimp only [Regs] at hR
  have he1o := hD1.2.1
  have hwf := hF.wf
  block_init
  step_pure [Nat.mod_lt i (by decide : 0 < 18446744073709551616)]
  step_load consuming hf1 hl1
  step_pure
  finish_block
  case isTrue =>
    obtain ⟨hpos, hk, hmsb⟩ := digit_pos hbr hd.2
    obtain ⟨hTf, hTr⟩ := (hT1.congr hF.bp) d.toNat (by omega)
    have hTl' := hTl d.toNat (by omega)
    obtain ⟨hacc, haccr⟩ := hQd.pt hF.acc.1
    have h17 := (hF.temps P.t17 (by simp [Ptrs.temps])).1
    have hov := entry_nov hL.bpo hk
    have hF₀ := hS ▸ hF
    have hQ₀ := hS ▸ hQd
    clear hQd
    block_init
    step_pure [hmsb]
    step_pure [hmsb, Nat.mod_eq_of_lt (show d.toNat < 18446744073709551616 by omega)]
    step_call using Edwards25519_add.call_eq_of consuming hTf hTr hacc haccr
    case hF =>
      subst hS'
      exact (hF.storePt hL (by simp [Ptrs.temps]) (by omega) _).1
    obtain ⟨-, hH, -⟩ :=
      hF₀.storePt hL (t := P.t17) (by simp [Ptrs.temps]) (Nat.le_add_right _ 38)
        (Edwards25519.add.spec Q (baseTbl d.toNat))
    replace hH : Holds S.mem P.t17 (Edwards25519.add.spec Q (baseTbl d.toNat)) := by
      rw [hS]; exact hH
    have hra : Room S.mem P.acc 1344 := hF.acc.1.2
    have hr17 : Room S.mem P.t17 1344 := h17.2.1
    checkpoint hck
    have hcp :=
      fun (S' : GlobalState)
        (hm :
          S' =
            ⟨S.alloc,
              S.mem.storeDef P.acc (S.mem.readAt P.t17 1344) (S.mem.definedAt P.t17 1344)⟩) =>
      hm ▸ hF.copy hL hH
    have hd : (Range.of P.acc 1344).Disjoint (Range.of P.t17 1344) :=
      .inl (hL.ne_acc (by simp [Ptrs.temps]))
    clear hH
    finish_block
    block_init
    step_memcpy consuming hF h17 hd hra hr17
    obtain ⟨hF, hQn⟩ := hcp S hS
    clear hcp
    finish_block
    refine
      hK E S
        (by
          rw [hE]; exact hArgs)
        (by env_reads) (by env_reads) hF ?_ ?_ ?_
    · rw [hS]; simp only [digitStep, hpos, ↓reduceIte]; exact hQn
    · rw [hS, ← hck]; simp [digitBlocks, hpos]
    · rw [hS, ← hck]
      dsimp only
      rw [MemoryState.eraseFrom_storeDef_of_le (hL.temp P.acc (by simp)).2.1,
        MemoryState.eraseFrom_storePt_of_le (hL.temp P.t17 (by simp [Ptrs.temps])).2.1]
  case isFalse =>
    have hnp := hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      obtain ⟨hneg, hnpos, hov8, hsub, hk, hmsb⟩ := digit_neg hbr hd.1
      obtain ⟨hTf, hTr⟩ := (hT1.congr hF.bp) (-d).toNat (by omega)
      have hTl' := hTl (-d).toNat (by omega)
      obtain ⟨hacc, haccr⟩ := hQd.pt hF.acc.1
      have h16 := (hF.temps P.t16 (by simp [Ptrs.temps])).1
      have hov := entry_nov hL.bpo hk
      have hF₀ := hS ▸ hF
      clear hQd
      block_init
      step_pure [hov8, hsub] with m
      rw [← hm] at hk hmsb hTf hTr hTl' hov
      step_pure [hmsb]
      step_pure [hmsb, Nat.mod_eq_of_lt (show m.toNat < 18446744073709551616 by omega)]
      step_call using Edwards25519_sub.call_eq_of consuming hTf hTr hacc haccr
      case hF =>
        subst hS'
        exact (hF.storePtCopy hL (by simp [Ptrs.temps]) (by omega) _).1
      obtain ⟨-, hH, -⟩ :=
        hF₀.storePtCopy hL (t := P.t16) (by simp [Ptrs.temps]) (Nat.le_add_right _ 47)
          (Edwards25519.sub.spec Q (baseTbl m.toNat))
      replace hH : Holds S.mem P.t16 (Edwards25519.sub.spec Q (baseTbl m.toNat)) := by
        rw [hS]; exact hH
      have hra : Room S.mem P.acc 1344 := hF.acc.1.2
      have hr16 : Room S.mem P.t16 1344 := h16.2.1
      checkpoint hck
      have hcp :
        ∀ S' : GlobalState,
          S' =
              ⟨S.alloc,
                S.mem.storeDef P.acc ((Edwards25519.sub.spec Q (baseTbl m.toNat)).raw 0#1)
                  (S.mem.definedAt P.t16 1344)⟩ →
            Facts P M S' ∧ Holds S'.mem P.acc (Edwards25519.sub.spec Q (baseTbl m.toNat)) := by
        intro S' hm
        subst hm
        have h := hF.copy hL hH
        rw [hH.1] at h
        exact h
      have hd : (Range.of P.acc 1344).Disjoint (Range.of P.t16 1344) :=
        .inl (hL.ne_acc (by simp [Ptrs.temps]))
      clear hH
      finish_block
      block_init
      step_memcpy consuming hF h16 hd hra hr16
      obtain ⟨hF, hQn⟩ := hcp S hS
      clear hcp
      finish_block
      refine
        hK E S
          (by
            rw [hE]; exact hArgs)
          (by env_reads) (by env_reads) hF ?_ ?_ ?_
      · simp only [digitStep, hnpos, hneg, ↓reduceIte, ← hm]; exact hQn
      · rw [hS, ← hck]; simp [digitBlocks, hnpos, hneg]
      · rw [hS, ← hck]
        dsimp only
        rw [MemoryState.eraseFrom_storeDef_of_le (hL.temp P.acc (by simp)).2.1,
          MemoryState.eraseFrom_storeDef_of_le (hL.temp P.t16 (by simp [Ptrs.temps])).2.1]
    case isFalse =>
      obtain ⟨h1, h2⟩ := digit_zero hnp hbr
      refine
        hK E S
          (by
            rw [hE]; exact hArgs)
          (by env_reads) (by env_reads) (hS ▸ hF) ?_ ?_ ?_
      · simp only [digitStep, h1, h2, ↓reduceIte]; exact hQd
      · rw [hS]; simp [digitBlocks, h1, h2]
      · rw [hS]

-- two branches, each a call and a copy, the loop's facts carried
set_option maxHeartbeats 1000000 in
/-- `^bb7`: `s1`'s digit at `pos = i` on the accumulator; on to `^bb12`. -/
theorem digit2_block (P : Ptrs) (N : Nat) (hL : Layout P N) (M : MemoryState) (x2 : BitVec 256)
    (hD2 : DigitsAt M P.e2 x2) (T : Nat → ZPt) (hT2 : TableAt M P.tb T)
    (hTl : ∀ k < 9, (T k).Lt (2 ^ 53)) (out s1 p2 s2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 64)
    (hd : -8 ≤ (Edwards25519.slide.digit x2 i).toInt ∧ (Edwards25519.slide.digit x2 i).toInt ≤ 8)
    (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : Regs P E) (hRi : E ⊨ [%3511 := BitVec.ofNat 64 i])
    (hF : Facts P M S) (hQd : Holds S.mem P.acc Q)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        Args E' out s1 p2 s2 →
          Regs P E' →
          (E' ⊨ [%3511 := BitVec.ofNat 64 i]) →
          Facts P M S' →
          Holds S'.mem P.acc (digitStep T (Edwards25519.slide.digit x2 i) Q) →
          S'.alloc.nextFreeBlock =
            S.alloc.nextFreeBlock + digitBlocks (Edwards25519.slide.digit x2 i) →
          S'.mem.eraseFrom N = S.mem.eraseFrom N →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb12 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb7 S >>= g) = K := by
  obtain ⟨hf1, hl1⟩ := (hD2.congr hF.e2).lane hi
  generalize Edwards25519.slide.digit x2 i = d at hd hl1 hK
  dsimp only [Regs] at hR
  have he2o := hD2.2.1
  have hwf := hF.wf
  block_init
  step_pure [Nat.mod_lt i (by decide : 0 < 18446744073709551616)]
  step_load consuming hf1 hl1
  step_pure
  finish_block
  case isTrue =>
    obtain ⟨hpos, hk, hmsb⟩ := digit_pos hbr hd.2
    obtain ⟨hTf, hTr⟩ := (hT2.congr hF.tb) d.toNat (by omega)
    have hTl' := hTl d.toNat (by omega)
    obtain ⟨hacc, haccr⟩ := hQd.pt hF.acc.1
    have h15 := (hF.temps P.t15 (by simp [Ptrs.temps])).1
    have hov := entry_nov hL.tbo hk
    have hF₀ := hS ▸ hF
    have hQ₀ := hS ▸ hQd
    clear hQd
    block_init
    step_pure [hmsb]
    step_pure [hmsb, Nat.mod_eq_of_lt (show d.toNat < 18446744073709551616 by omega)]
    step_call using Edwards25519_add.call_eq_of consuming hTf hTr hacc haccr
    case hF =>
      subst hS'
      exact (hF.storePt hL (by simp [Ptrs.temps]) (by omega) _).1
    obtain ⟨-, hH, -⟩ :=
      hF₀.storePt hL (t := P.t15) (by simp [Ptrs.temps]) (Nat.le_add_right _ 38)
        (Edwards25519.add.spec Q (T d.toNat))
    replace hH : Holds S.mem P.t15 (Edwards25519.add.spec Q (T d.toNat)) := by
      rw [hS]; exact hH
    have hra : Room S.mem P.acc 1344 := hF.acc.1.2
    have hr15 : Room S.mem P.t15 1344 := h15.2.1
    checkpoint hck
    have hcp :=
      fun (S' : GlobalState)
        (hm :
          S' =
            ⟨S.alloc,
              S.mem.storeDef P.acc (S.mem.readAt P.t15 1344) (S.mem.definedAt P.t15 1344)⟩) =>
      hm ▸ hF.copy hL hH
    have hd : (Range.of P.acc 1344).Disjoint (Range.of P.t15 1344) :=
      .inl (hL.ne_acc (by simp [Ptrs.temps]))
    clear hH
    finish_block
    block_init
    step_memcpy consuming hF h15 hd hra hr15
    obtain ⟨hF, hQn⟩ := hcp S hS
    clear hcp
    finish_block
    refine
      hK E S
        (by
          rw [hE]; exact hArgs)
        (by env_reads) (by env_reads) hF ?_ ?_ ?_
    · rw [hS]; simp only [digitStep, hpos, ↓reduceIte]; exact hQn
    · rw [hS, ← hck]; simp [digitBlocks, hpos]
    · rw [hS, ← hck]
      dsimp only
      rw [MemoryState.eraseFrom_storeDef_of_le (hL.temp P.acc (by simp)).2.1,
        MemoryState.eraseFrom_storePt_of_le (hL.temp P.t15 (by simp [Ptrs.temps])).2.1]
  case isFalse =>
    have hnp := hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      obtain ⟨hneg, hnpos, hov8, hsub, hk, hmsb⟩ := digit_neg hbr hd.1
      obtain ⟨hTf, hTr⟩ := (hT2.congr hF.tb) (-d).toNat (by omega)
      have hTl' := hTl (-d).toNat (by omega)
      obtain ⟨hacc, haccr⟩ := hQd.pt hF.acc.1
      have h14 := (hF.temps P.t14 (by simp [Ptrs.temps])).1
      have hov := entry_nov hL.tbo hk
      have hF₀ := hS ▸ hF
      clear hQd
      block_init
      step_pure [hov8, hsub] with m
      rw [← hm] at hk hmsb hTf hTr hTl' hov
      step_pure [hmsb]
      step_pure [hmsb, Nat.mod_eq_of_lt (show m.toNat < 18446744073709551616 by omega)]
      step_call using Edwards25519_sub.call_eq_of consuming hTf hTr hacc haccr
      case hF =>
        subst hS'
        exact (hF.storePtCopy hL (by simp [Ptrs.temps]) (by omega) _).1
      obtain ⟨-, hH, -⟩ :=
        hF₀.storePtCopy hL (t := P.t14) (by simp [Ptrs.temps]) (Nat.le_add_right _ 47)
          (Edwards25519.sub.spec Q (T m.toNat))
      replace hH : Holds S.mem P.t14 (Edwards25519.sub.spec Q (T m.toNat)) := by
        rw [hS]; exact hH
      have hra : Room S.mem P.acc 1344 := hF.acc.1.2
      have hr14 : Room S.mem P.t14 1344 := h14.2.1
      checkpoint hck
      have hcp :
        ∀ S' : GlobalState,
          S' =
              ⟨S.alloc,
                S.mem.storeDef P.acc ((Edwards25519.sub.spec Q (T m.toNat)).raw 0#1)
                  (S.mem.definedAt P.t14 1344)⟩ →
            Facts P M S' ∧ Holds S'.mem P.acc (Edwards25519.sub.spec Q (T m.toNat)) := by
        intro S' hm
        subst hm
        have h := hF.copy hL hH
        rw [hH.1] at h
        exact h
      have hd : (Range.of P.acc 1344).Disjoint (Range.of P.t14 1344) :=
        .inl (hL.ne_acc (by simp [Ptrs.temps]))
      clear hH
      finish_block
      block_init
      step_memcpy consuming hF h14 hd hra hr14
      obtain ⟨hF, hQn⟩ := hcp S hS
      clear hcp
      finish_block
      refine
        hK E S
          (by
            rw [hE]; exact hArgs)
          (by env_reads) (by env_reads) hF ?_ ?_ ?_
      · simp only [digitStep, hnpos, hneg, ↓reduceIte, ← hm]; exact hQn
      · rw [hS, ← hck]; simp [digitBlocks, hnpos, hneg]
      · rw [hS, ← hck]
        dsimp only
        rw [MemoryState.eraseFrom_storeDef_of_le (hL.temp P.acc (by simp)).2.1,
          MemoryState.eraseFrom_storeDef_of_le (hL.temp P.t14 (by simp [Ptrs.temps])).2.1]
    case isFalse =>
      obtain ⟨h1, h2⟩ := digit_zero hnp hbr
      refine
        hK E S
          (by
            rw [hE]; exact hArgs)
          (by env_reads) (by env_reads) (hS ▸ hF) ?_ ?_ ?_
      · simp only [digitStep, h1, h2, ↓reduceIte]; exact hQd
      · rw [hS]; simp [digitBlocks, h1, h2]
      · rw [hS]

/-- A point stored where the padding is clear: the slot holds it. -/
theorem holds_storePt {m : MemoryState} {t : Pointer} (hr : m.PtRoom t) (hc : m.PadClear t)
    (A : ZPt) : Holds (m.storePt t A 0#1) t A :=
  ⟨MemoryState.readAt_storePt_padClear hr hc, MemoryState.definedAt_storePt_padClear hr hc⟩

/-- `2P`'s `x, y, z` are below `2^53`. -/
theorem dbl_lt53 (A : ZPt) :
    Fe.Lt (Edwards25519.dbl.spec A).x (2 ^ 53) ∧
      Fe.Lt (Edwards25519.dbl.spec A).y (2 ^ 53) ∧ Fe.Lt (Edwards25519.dbl.spec A).z (2 ^ 53) :=
  have h := Edwards25519.dbl.spec_lt A
  ⟨h.1.mono (by decide), h.2.1.mono (by decide), h.2.2.1.mono (by decide)⟩

/-- A small `pos` is `0` exactly when it is. -/
theorem eq_zero_of_ofNat64 {i : Nat} (hi : i < 2 ^ 64) (h : BitVec.ofNat 64 i = 0#64) : i = 0 := by
  have := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt hi] at this
  exact this

/-- `pos - 1`, as `pos + -1`, on a positive `pos`. -/
theorem add_neg_one64 {i : Nat} (h1 : 1 ≤ i) (h : i < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow 18446744073709551615#64 = false ∧
      BitVec.ofNat 64 i + 18446744073709551615#64 = BitVec.ofNat 64 (i - 1) := by
  have hn : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (18446744073709551615#64).toInt = -1 := by decide
  refine
    ⟨by
      simp [BitVec.saddOverflow, hn, hm]; omega, ?_⟩
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

set_option hygiene false in
/-- One `dbl` of the point at `p` (`A`, its field elements known) into the temporary `t`: `hH` says
`t` holds it, `hF` carried. -/
local macro "dbl_into " t:term:max A:term:max hb:term:max : tactic =>
  `(tactic|
    ( obtain ⟨hX, hY, hZ⟩ := $hb
      have hpt := (hF.temps $t (by simp [Ptrs.temps])).1
      try checkpoint hck
      have hp := fun m' (hm : m' = S.mem.storePt $t (Edwards25519.dbl.spec $A) 0#1) =>
        hm ▸
          holds_storePt (hF.temps $t (by simp [Ptrs.temps])).1
            (hF.temps $t (by simp [Ptrs.temps])).2 (Edwards25519.dbl.spec $A)
      step_call using (Edwards25519_dbl.call_eq_of (P := $A)) consuming hpf hpr hX hY hZ hpt
      case hF =>
        subst hS'
        exact (hF.storePt hL (by simp [Ptrs.temps]) (by omega) _).1
      have hH := hp _ (congrArg GlobalState.mem hS)
      clear hp))

/-- `^bb12`: out at `pos = 0`, else four doublings and around at `pos - 1`. -/
theorem tail_block (P : Ptrs) (N : Nat) (hL : Layout P N) (M : MemoryState) (out s1 p2 s2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 64) (Q : ZPt)
    (hQ : Q.Lt (2 ^ 53)) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : Regs P E) (hRi : E ⊨ [%3511 := BitVec.ofNat 64 i])
    (hF : Facts P M S) (hQd : Holds S.mem P.acc Q)
    (hexit :
      i = 0 →
        ∀ E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫,
          Args E' out s1 p2 s2 →
            Regs P E' → (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb16 S >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
            Args E' out s1 p2 s2 →
              Regs P E' →
              (E' ⊨ [%3511 := BitVec.ofNat 64 j]) →
              Facts P M S' →
              Holds S'.mem P.acc (dbl4 Q) →
              S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 112 →
              S'.mem.eraseFrom N = S.mem.eraseFrom N →
              (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb5 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb12 S >>= g) = K := by
  have hwf := hF.wf
  dsimp only [Regs] at hR
  block_init
  step_pure
  finish_block
  case isTrue =>
    exact
      hexit (eq_zero_of_ofNat64 (by omega) hbr) E
        (by
          rw [hE]; exact hArgs)
        (by env_reads)
  case isFalse =>
    have hi0 : 1 ≤ i := Nat.one_le_iff_ne_zero.mpr fun h => hbr (by rw [h])
    obtain ⟨hpf, hpr⟩ := hQd.pt hF.acc.1
    clear hQd
    block_init
    dbl_into P.t13 Q(show _ ∧ _ ∧ _ from ⟨hQ.1, hQ.2.1, hQ.2.2.1⟩)
    obtain ⟨hpf, hpr⟩ := hH.pt (hF.temps P.t13 (by simp [Ptrs.temps])).1
    clear hH
    dbl_into P.t12(Edwards25519.dbl.spec Q)(dbl_lt53 Q)
    obtain ⟨hpf, hpr⟩ := hH.pt (hF.temps P.t12 (by simp [Ptrs.temps])).1
    clear hH
    dbl_into
      P.t11(Edwards25519.dbl.spec (Edwards25519.dbl.spec Q))(dbl_lt53 (Edwards25519.dbl.spec Q))
    obtain ⟨hpf, hpr⟩ := hH.pt (hF.temps P.t11 (by simp [Ptrs.temps])).1
    clear hH
    obtain ⟨hX, hY, hZ⟩ := dbl_lt53 (Edwards25519.dbl.spec (Edwards25519.dbl.spec Q))
    have hpt := hF.acc.1
    checkpoint hck
    have hp := fun m' (hm : m' = S.mem.storePt P.acc (dbl4 Q) 0#1) =>
      hm ▸ holds_storePt hF.acc.1 hF.acc.2 (dbl4 Q)
    step_call using
      (Edwards25519_dbl.call_eq_of (P :=
        Edwards25519.dbl.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec Q)))) consuming
      hpf hpr hX hY hZ hpt
    case hF =>
      subst hS'
      exact (hF.storePt_acc hL (by omega) _).1
    have hH := hp _ (congrArg GlobalState.mem hS)
    clear hp
    obtain ⟨ho, hn⟩ := add_neg_one64 hi0 (by omega)
    step_pure [ho, hn]
    finish_block
    refine
      hback (i - 1) (by omega) E S
        (by
          rw [hE]; exact hArgs)
        (by env_reads) (by env_reads) hF hH ?_ ?_
    · clear hH hF
      subst_vars
      simp only
    · clear hH hF
      subst_vars
      dsimp only
      rw [MemoryState.eraseFrom_storePt_of_le (hL.temp P.acc (by simp)).2.1,
        MemoryState.eraseFrom_storePt_of_le (hL.temp P.t11 (by simp [Ptrs.temps])).2.1,
        MemoryState.eraseFrom_storePt_of_le (hL.temp P.t12 (by simp [Ptrs.temps])).2.1,
        MemoryState.eraseFrom_storePt_of_le (hL.temp P.t13 (by simp [Ptrs.temps])).2.1]

/-- A digit's step keeps limbs below `2^53`. -/
theorem digitStep_lt (tbl : Nat → ZPt) (d : BitVec 8) {Q : ZPt} (hQ : Q.Lt (2 ^ 53)) :
    (digitStep tbl d Q).Lt (2 ^ 53) := by
  unfold digitStep
  split
  · exact ZPt.Lt.mono53 (Edwards25519.add.spec_lt _ _)
  · split
    · exact ZPt.Lt.mono53 (Edwards25519.sub.spec_lt _ _)
    · exact hQ

/-- `dbl4`'s limbs are below `2^53`. -/
theorem dbl4_lt (A : ZPt) : (dbl4 A).Lt (2 ^ 53) :=
  ZPt.Lt.mono53 (Edwards25519.dbl.spec_lt _)

/-- The loop's fixed data: the digits of `x1`, `x2` and the tables `baseTbl`, `T` as `M` holds them,
the entries' limbs below `2^53`, the digits in `[-8, 8]`. -/
structure Data (P : Ptrs) (M : MemoryState) (x1 x2 : BitVec 256) (T : Nat → ZPt) : Prop where
  d1 : DigitsAt M P.e1 x1
  d2 : DigitsAt M P.e2 x2
  t1 : TableAt M P.bp baseTbl
  t2 : TableAt M P.tb T
  l1 : ∀ k < 9, (baseTbl k).Lt (2 ^ 53)
  l2 : ∀ k < 9, (T k).Lt (2 ^ 53)
  b1 :
    ∀ k < 64, -8 ≤ (Edwards25519.slide.digit x1 k).toInt ∧ (Edwards25519.slide.digit x1 k).toInt ≤ 8
  b2 :
    ∀ k < 64, -8 ≤ (Edwards25519.slide.digit x2 k).toInt ∧ (Edwards25519.slide.digit x2 k).toInt ≤ 8

/-- One iteration at `pos = i`: both digits, then out at `0`, else four doublings and around. -/
theorem iter (P : Ptrs) (N : Nat) (hL : Layout P N) (M : MemoryState) (x1 x2 : BitVec 256)
    (T : Nat → ZPt) (hD : Data P M x1 x2 T) (out s1 p2 s2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 64) (Q : ZPt)
    (hQ : Q.Lt (2 ^ 53)) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : Regs P E) (hRi : E ⊨ [%3511 := BitVec.ofNat 64 i])
    (hF : Facts P M S) (hQd : Holds S.mem P.acc Q)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
          Args E' out s1 p2 s2 →
            Regs P E' →
            Facts P M S' →
            Holds S'.mem P.acc (posStep T x1 x2 i Q) →
            S'.alloc.nextFreeBlock =
              S.alloc.nextFreeBlock + digitBlocks (Edwards25519.slide.digit x1 i) +
                digitBlocks (Edwards25519.slide.digit x2 i) →
            S'.mem.eraseFrom N = S.mem.eraseFrom N →
            (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb16 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
            Args E' out s1 p2 s2 →
              Regs P E' →
              (E' ⊨ [%3511 := BitVec.ofNat 64 j]) →
              Facts P M S' →
              Holds S'.mem P.acc (dbl4 (posStep T x1 x2 i Q)) →
              S'.alloc.nextFreeBlock =
                S.alloc.nextFreeBlock + digitBlocks (Edwards25519.slide.digit x1 i) +
                  digitBlocks (Edwards25519.slide.digit x2 i) +
                  112 →
              S'.mem.eraseFrom N = S.mem.eraseFrom N →
              (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb5 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb5 S >>= g) = K := by
  refine
    digit1_block P N hL M x1 hD.d1 hD.t1 hD.l1 out s1 p2 s2 g K i hi (hD.b1 i hi) Q hQ S E hArgs hR
      hRi hF hQd fun E₁ S₁ hA₁ hR₁ hRi₁ hF₁ hQ₁ hn₁ he₁ => ?_
  have hQb₁ := digitStep_lt baseTbl (Edwards25519.slide.digit x1 i) hQ
  refine
    digit2_block P N hL M x2 hD.d2 T hD.t2 hD.l2 out s1 p2 s2 g K i hi (hD.b2 i hi) _ hQb₁ S₁ E₁ hA₁
      hR₁ hRi₁ hF₁ hQ₁ fun E₂ S₂ hA₂ hR₂ hRi₂ hF₂ hQ₂ hn₂ he₂ => ?_
  have hQb₂ := digitStep_lt T (Edwards25519.slide.digit x2 i) hQb₁
  exact
    tail_block P N hL M out s1 p2 s2 g K i hi _ hQb₂ S₂ E₂ hA₂ hR₂ hRi₂ hF₂ hQ₂
      (fun h0 E₃ hA₃ hR₃ => hexit h0 E₃ S₂ hA₃ hR₃ hF₂ hQ₂ (by omega) (he₂.trans he₁))
      fun j hj E₃ S₃ hA₃ hR₃ hRi₃ hF₃ hQ₃ hn₃ he₃ =>
      hback j hj E₃ S₃ hA₃ hR₃ hRi₃ hF₃ hQ₃ (by omega) (he₃.trans (he₂.trans he₁))

/-- The loop from `^bb5` at `pos = i`: the accumulator becomes `ladder … i Q`, then `^bb16`. -/
theorem loop (P : Ptrs) (N : Nat) (hL : Layout P N) (M : MemoryState) (x1 x2 : BitVec 256)
    (T : Nat → ZPt) (hD : Data P M x1 x2 T) (out s1 p2 s2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i,
      i < 64 →
        ∀ (Q : ZPt) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫),
          Args E out s1 p2 s2 →
            Regs P E →
            (E ⊨ [%3511 := BitVec.ofNat 64 i]) →
            Facts P M S →
            Holds S.mem P.acc Q →
            Q.Lt (2 ^ 53) →
            (∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
              Args E' out s1 p2 s2 →
                Regs P E' →
                Facts P M S' →
                Holds S'.mem P.acc (ladder T x1 x2 i Q) →
                S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + ladderBlocks x1 x2 i →
                S'.mem.eraseFrom N = S.mem.eraseFrom N →
                (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb16 S' >>= g) = K) →
            (Edwards25519_mulDoubleBasePublic.runFrom E ^bb5 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi Q S E hA hR hRi hF hQd hQ hK
    exact
      iter P N hL M x1 x2 T hD out s1 p2 s2 g K 0 hi Q hQ S E hA hR hRi hF hQd
        (fun _ E' S' hA' hR' hF' hQ' hn he =>
          hK E' S' hA' hR' hF' hQ'
            (by
              rw [hn]; simp only [ladderBlocks]; omega)
            he)
        fun j hj => absurd hj (by omega)
  | succ j ih =>
    intro hi Q S E hA hR hRi hF hQd hQ hK
    refine
      iter P N hL M x1 x2 T hD out s1 p2 s2 g K (j + 1) hi Q hQ S E hA hR hRi hF hQd
        (fun h => absurd h (by omega)) fun j' hj E' S' hA' hR' hRi' hF' hQ' hn he => ?_
    obtain rfl : j = j' := by omega
    exact
      ih (by omega) _ S' E' hA' hR' hRi' hF' hQ' (dbl4_lt _)
        fun E'' S'' hA'' hR'' hF'' hQ'' hn'' he'' =>
        hK E'' S'' hA'' hR'' hF'' hQ''
          (by
            rw [hn'', hn]; simp only [ladderBlocks]; omega)
          (he''.trans he)

/-- The identity's limbs are below `2^53`. -/
theorem identity_lt : Edwards25519.identity.Lt (2 ^ 53) := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> intro i <;> fin_cases i <;> decide

/-- `rejectIdentity`'s `call_eq` on the point `P` read at `p`. -/
theorem Edwards25519_rejectIdentity.call_eq_of (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : s.mem.LimbsFit p) (hP : s.mem.readPt p = P) (hx : Fe.Lt P.x (2 ^ 63)) :
    Edwards25519_rejectIdentity.call (Edwards25519_rejectIdentity.args (.value p)) s =
      .value
        (.cons (.value (Edwards25519.rejectIdentity.spec P)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  subst hP
  exact Edwards25519_rejectIdentity.call_eq p s hwf hp hx

/-- `slide`'s `call_eq` on the scalar `x` read at `sp`. -/
theorem Edwards25519_slide.call_eq_of (out sp : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 512) (hsp : Fits s.mem sp 256) (hso : ¬sp.offset.uaddOverflow 32#64)
    (hx : s.mem.readAt sp 256 = x) (hmsb : x.msb = false) :
    Edwards25519_slide.call (Edwards25519_slide.args (.value out) (.value sp)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem := s.mem.storeAt out (BitVec.packLanes (Edwards25519.slide.spec x)) }) := by
  subst hx
  exact Edwards25519_slide.call_eq out sp s hwf hout hsp hso hmsb

set_option exponentiation.threshold 1344 in
/-- The identity global's bits: the identity as a fresh slot holds it. -/
theorem identityBits_eq : Edwards25519.identityBits = Edwards25519.identity.raw 0 := by
  simp only [ZPt.raw, ZPt.over, spliceBits_eq]
  decide +kernel

set_option exponentiation.threshold 1344 in
/-- Its definedness. -/
theorem identityDef_eq : Edwards25519.identityDef = ZPt.rawDef := by
  simp only [ZPt.rawDef, ZPt.overDef, spliceBits_eq]
  decide +kernel

/-- `^bb2`: both scalars' digits, the accumulator the identity, then the loop from `pos = 63`. -/
theorem from_bb2 (P : Ptrs) (N : Nat) (hL : Layout P N) (x1 x2 : BitVec 256) (T : Nat → ZPt)
    (hl1 : ∀ k < 9, (baseTbl k).Lt (2 ^ 53)) (hl2 : ∀ k < 9, (T k).Lt (2 ^ 53))
    (hb1 :
      ∀ k < 64,
        -8 ≤ (Edwards25519.slide.digit x1 k).toInt ∧ (Edwards25519.slide.digit x1 k).toInt ≤ 8)
    (hb2 :
      ∀ k < 64,
        -8 ≤ (Edwards25519.slide.digit x2 k).toInt ∧ (Edwards25519.slide.digit x2 k).toInt ≤ 8)
    (hm1 : x1.msb = false) (hm2 : x2.msb = false) (out s1 p2 s2 idp : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (S : GlobalState)
    (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (hArgs : Args E out s1 p2 s2) (hR : Regs P E)
    (hR' : E ⊨ [%3488 := idp, %3490 := 63#64]) (hwf : S.WF)
    (htemps : ∀ u ∈ P.acc :: P.temps, S.mem.PtRoom u ∧ S.mem.PadClear u) (he1 : Room S.mem P.e1 512)
    (he1o : P.e1.offset = 0) (he2 : Room S.mem P.e2 512) (he2o : P.e2.offset = 0)
    (hs1 : Fits S.mem s1 256) (hs1o : ¬s1.offset.uaddOverflow 32#64)
    (hx1 : S.mem.readAt s1 256 = x1) (hs2 : Fits S.mem s2 256)
    (hs2o : ¬s2.offset.uaddOverflow 32#64) (hx2 : S.mem.readAt s2 256 = x2)
    (ht1 : TableAt S.mem P.bp baseTbl) (ht2 : TableAt S.mem P.tb T) (hid : Room S.mem idp 1344)
    (hidb : S.mem.readAt idp 1344 = Edwards25519.identityBits)
    (hidd : S.mem.definedAt idp 1344 = Edwards25519.identityDef) (h12 : P.e1.id ≠ P.e2.id)
    (h1s : P.e1.id ≠ s2.id) (h1b : P.e1.id ≠ P.bp.id) (h1t : P.e1.id ≠ P.tb.id)
    (h2b : P.e2.id ≠ P.bp.id) (h2t : P.e2.id ≠ P.tb.id) (h1i : P.e1.id ≠ idp.id)
    (h2i : P.e2.id ≠ idp.id) (hai : P.acc.id ≠ idp.id) (hN1 : N ≤ P.e1.id.id) (hN2 : N ≤ P.e2.id.id)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        Args E' out s1 p2 s2 →
          Regs P E' →
          S'.WF →
          S'.mem.PtRoom P.acc →
          Holds S'.mem P.acc (ladder T x1 x2 63 Edwards25519.identity) →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 6 + ladderBlocks x1 x2 63 →
          S'.mem.eraseFrom N = S.mem.eraseFrom N →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb16 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb2 S >>= g) = K := by
  dsimp only [Regs] at hR
  unfold Args at hArgs
  block_init
  step_call using Edwards25519_slide.call_eq_of
  case ht1 =>
    subst hS'; exact ht1.storeAt h1b _
  case ht2 =>
    subst hS'; exact ht2.storeAt h1t _
  have hD1 : DigitsAt S.mem P.e1 x1 := ⟨hfits, he1o, hread⟩
  clear hread hfits
  step_call using Edwards25519_slide.call_eq_of
  case ht1 =>
    subst hS'; exact ht1.storeAt h2b _
  case ht2 =>
    subst hS'; exact ht2.storeAt h2t _
  case hD1 =>
    subst hS'; exact hD1.congr (MemoryState.getElem?_storeAt_ne h12)
  have hD2 : DigitsAt S.mem P.e2 x2 := ⟨hfits, he2o, hread⟩
  clear hread hfits
  have hDat := fun (m : MemoryState) (hm : m = S.mem) =>
    (hm ▸ ⟨hD1, hD2, ht1, ht2, hl1, hl2, hb1, hb2⟩ : Data P m x1 x2 T)
  have htm : ∀ u ∈ P.acc :: P.temps, S.mem.PtRoom u ∧ S.mem.PadClear u := by
    intro u hu
    obtain ⟨⟨ho, hr⟩, hc⟩ := htemps u hu
    rw [hS]
    exact
      ⟨⟨ho, hr.storeAt.storeAt⟩,
        (hc.storeAt (hL.temp u hu).2.2.1.symm).storeAt (hL.temp u hu).2.2.2.1.symm⟩
  have hra := (htm P.acc List.mem_cons_self).1
  have htm' : ∀ u ∈ P.temps, S.mem.PtRoom u ∧ S.mem.PadClear u := fun u hu =>
    htm u (List.mem_cons_of_mem _ hu)
  have hd : (Range.of P.acc 1344).Disjoint (Range.of idp 1344) := .inl hai
  clear hD1 hD2 ht1 ht2 htemps htm hs1 hs2
  checkpoint hck
  rename' S => S₁
  have hcp :=
    fun m' (hm : m' = S₁.mem.storeDef P.acc Edwards25519.identityBits Edwards25519.identityDef) =>
    (hm ▸
        ⟨(MemoryState.readAt_storeDef_self hra.2.inBounds _ _).trans identityBits_eq,
          (MemoryState.definedAt_storeDef_self hra.2.inBounds _ _).trans identityDef_eq⟩ :
      Holds m' P.acc Edwards25519.identity)
  step_memcpy consuming hidb hidd hd
  have hH := hcp _ (congrArg GlobalState.mem hS)
  clear hcp
  have hsame (q : Pointer) (hq : q.id ≠ P.acc.id) : S.mem[q.id]? = S₁.mem[q.id]? := by
    rw [hS]; exact MemoryState.getElem?_storeDef_ne hq
  have hF : Facts P S₁.mem S := by
    refine
      ⟨hwf, hsame _ (hL.temp P.acc List.mem_cons_self).2.2.1.symm,
        hsame _ (hL.temp P.acc List.mem_cons_self).2.2.2.1.symm,
        hsame _ (hL.temp P.acc List.mem_cons_self).2.2.2.2.1.symm,
        hsame _ (hL.temp P.acc List.mem_cons_self).2.2.2.2.2.symm, fun u hu => ?_, hra, hH.padClear⟩
    obtain ⟨⟨ho, hr⟩, hc⟩ := htm' u hu
    rw [hS]
    exact ⟨⟨ho, hr.storeDef⟩, hc.storeDef (hL.acc_ne u hu).symm⟩
  have hDat := hDat _ rfl
  clear htm' hsame
  finish_block
  refine
    loop P N hL S₁.mem x1 x2 T hDat out s1 p2 s2 g K 63 (by omega) _ S E hArgs (by env_reads)
      (by env_reads) hF hH identity_lt fun E' S' hA' hR' hF' hQ' hn' he' =>
      hK E' S' hA' hR' hF'.wf hF'.acc.1 hQ' ?_ (he'.trans ?_)
  · rw [hn', hS, ← hck]
  · rw [hS, ← hck]
    dsimp only
    rw [MemoryState.eraseFrom_storeDef_of_le (hL.temp P.acc List.mem_cons_self).2.1,
      MemoryState.eraseFrom_storeAt_of_le hN2, MemoryState.eraseFrom_storeAt_of_le hN1]

/-- `^bb16`: error code `0` at `out + 168`, the accumulator `Q` copied to `out`; on to `^bb1`. -/
theorem exit_block (P : Ptrs) (out s1 p2 s2 : Pointer) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (Q : ZPt) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : Regs P E) (hwf : S.WF) (hacc : S.mem.PtRoom P.acc)
    (hQd : Holds S.mem P.acc Q) (hFo : Room S.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hne : out.id ≠ P.acc.id)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        S' = ⟨S.alloc, (S.mem.storeAt (out.add 168#64) 0#16).storePtCopy out Q 0#1⟩ →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb1 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb16 S >>= g) = K := by
  have hFo168 : Room S.mem (out.add 168#64) 16 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by decide) hFo
  have hFo1344 := hFo.mono (show 1344 ≤ 1408 by omega)
  have hd : (Range.of out 1344).Disjoint (Range.of P.acc 1344) := .inl hne
  have hra := hacc.2
  obtain ⟨hqb, hqd⟩ := hQd
  dsimp only [Regs] at hR
  unfold Args at hArgs
  block_init
  step_pure
  step_store
  step_memcpy consuming hfits_out_168 hqb hqd
  finish_block
  exact hK E S hS

/-- `^bb4`: `error.WeakPublicKey`'s result copied to `out`; on to `^bb1`. -/
theorem weak_block (out s1 p2 s2 wk : Pointer) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : E ⊨ [%3486 := wk, %3487 := 176#64]) (hwf : S.WF)
    (hFo : Room S.mem out 1408) (hFw : Room S.mem wk 1408) (hne : out.id ≠ wk.id)
    (hwb : S.mem.readAt wk 1408 = Edwards25519_mulDoubleBasePublic_weak.bits)
    (hwd : S.mem.definedAt wk 1408 = weakDef)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        S' = ⟨S.alloc, S.mem.storeDef out Edwards25519_mulDoubleBasePublic_weak.bits weakDef⟩ →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb1 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb4 S >>= g) = K := by
  have hd : (Range.of out 1408).Disjoint (Range.of wk 1408) := .inl hne
  unfold Args at hArgs
  block_init
  step_memcpy consuming hwb hwd
  finish_block
  exact hK E S hS

/-- The base point's table, entries `0 … 8`, below `2^53`. -/
theorem baseTbl_lt : ∀ k < 9, (baseTbl k).Lt (2 ^ 53) := fun k hk => by
  simp only [baseTbl, show k < 16 by omega, dite_true]
  exact ZPt.Lt.mono53 (Edwards25519.basePointPc.pts_lt ⟨k, by omega⟩)

/-- `precompute`'s table, entries `0 … 8`, below `2^53`. -/
theorem pcTbl_lt {P : ZPt} (h : P.Lt (2 ^ 53)) : ∀ k < 9, (pcTbl P k).Lt (2 ^ 53) := by
  intro k hk
  have ha := fun A B => ZPt.Lt.mono53 (Edwards25519.add.spec_lt A B)
  have hd := fun A => ZPt.Lt.mono53 (Edwards25519.dbl.spec_lt A)
  rcases k with _ | _ | _ | _ | _ | _ | _ | _ | _ | k
  · exact identity_lt
  · exact h
  · exact hd _
  · exact ha _ _
  · exact hd _
  · exact ha _ _
  · exact hd _
  · exact ha _ _
  · exact hd _
  · omega

/-- `slide`'s digits of a scalar below `2^255` are in `[-8, 8]`. -/
theorem digit_bound {x : BitVec 256} (h : x.msb = false) (k : Nat) (hk : k < 64) :
    -8 ≤ (Edwards25519.slide.digit x k).toInt ∧ (Edwards25519.slide.digit x k).toInt ≤ 8 := by
  have := Edwards25519.slide.spec_digit x h ⟨k, hk⟩
  simp only [Edwards25519.slide.spec, Fin.getElem_fin, Vector.getElem_ofFn] at this
  exact ⟨this.1, this.2.1⟩

/-- The frame's slots: the temporaries `0 … 7`, the digits `8`, `9` of the slots' state `S₁`, the
globals of `S₀`'s; the second table the base point's (`S₀`'s slot `0`) or `S₁`'s slot `10`. -/
theorem layout_of_slots {S₀ S₁ : GlobalState}
    (h : S₁.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 3) (tb : Pointer)
    (htb : tb = S₀.slot 0 ∨ tb = S₁.slot 10) :
    Layout
      ⟨S₁.slot 0, S₁.slot 1, S₁.slot 2, S₁.slot 3, S₁.slot 4, S₁.slot 5, S₁.slot 6, S₁.slot 7,
        S₁.slot 8, S₁.slot 9, S₀.slot 0, tb⟩
      S₀.alloc.nextFreeBlock := by
  have hne (i j : Nat) (hij : i ≠ j) : (S₁.slot i).id ≠ (S₁.slot j).id := GlobalState.slot_id_ne hij
  have hb (i : Nat) : (S₁.slot i).id ≠ (S₀.slot 0).id := by
    simp [GlobalState.slot, h]; omega
  have ht (i : Nat) (hi : i ≠ 10) : (S₁.slot i).id ≠ tb.id := by
    rcases htb with rfl | rfl
    · exact hb i
    · exact hne i 10 hi
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro u hu
    simp only [Ptrs.temps, List.mem_cons, List.not_mem_nil, or_false] at hu
    rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
      exact
        ⟨rfl, by
          simp only [GlobalState.slot_id_id, h]; omega, hne _ _ (by decide), hne _ _ (by decide),
          hb _, ht _ (by decide)⟩
  · intro u hu
    simp only [Ptrs.temps, List.mem_cons, List.not_mem_nil, or_false] at hu
    rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> exact hne _ _ (by decide)
  · simp [GlobalState.slot]
  · rcases htb with rfl | rfl <;> simp [GlobalState.slot]

end Edwards25519_mulDoubleBasePublic

attribute [local mlir_transport] Edwards25519_mulDoubleBasePublic.TableAt.storeDef
  Edwards25519_mulDoubleBasePublic.TableAt.alloca

open Edwards25519_mulDoubleBasePublic in
-- eleven slots, three globals, the loop's lemmas applied in both of `is_base`'s branches
set_option maxHeartbeats 2000000 in
/-- `Edwards25519.mulDoubleBasePublic` stores at `out` `spec` of the scalars at `s1`, `s2` (below
`2^255`) and the point at `p2` (limbs below `2^53`, `is_base` known): `s1 B + s2 P2` with error code
`0`, or `error.WeakPublicKey`'s result. -/
public theorem Edwards25519_mulDoubleBasePublic.call_eq (out s1 p2 s2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : Room s.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hs1 : Fits s.mem s1 256) (hs1o : ¬s1.offset.uaddOverflow 32#64)
    (hm1 : (s.mem.readAt s1 256).msb = false) (hp2 : s.mem.PtFit p2)
    (hP2 : (s.mem.readPt p2).Lt (2 ^ 53)) (hs2 : Fits s.mem s2 256)
    (hs2o : ¬s2.offset.uaddOverflow 32#64) (hm2 : (s.mem.readAt s2 256).msb = false) :
    Edwards25519_mulDoubleBasePublic.call
        (Edwards25519_mulDoubleBasePublic.args (.value out) (.value s1) (.value p2) (.value s2)) s =
      .value
        (.nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (s.mem.readAt s1 256) (s.mem.readBase p2) (s.mem.readPt p2)
                    (s.mem.readAt s2 256)⟩,
            mem :=
              store s.mem out
                (spec (s.mem.readAt s1 256) (s.mem.readBase p2) (s.mem.readPt p2)
                  (s.mem.readAt s2 256)) }) := by
  generalize hRes :
    spec (s.mem.readAt s1 256) (s.mem.readBase p2) (s.mem.readPt p2) (s.mem.readAt s2 256) = Res
  generalize hk :
    blocks (s.mem.readAt s1 256) (s.mem.readBase p2) (s.mem.readPt p2) (s.mem.readAt s2 256) = k
  func_init
  obtain ⟨x1, hx1⟩ : ∃ x, S.mem.readAt s1 256 = x := ⟨_, rfl⟩
  obtain ⟨x2, hx2⟩ : ∃ x, S.mem.readAt s2 256 = x := ⟨_, rfl⟩
  obtain ⟨P2, hP2d⟩ : ∃ P, S.mem.readPt p2 = P := ⟨_, rfl⟩
  obtain ⟨b, hb⟩ : ∃ b, S.mem.readBase p2 = b := ⟨_, rfl⟩
  rw [hx1, hx2, hP2d, hb] at hRes hk
  rw [hx1] at hm1
  rw [hx2] at hm2
  rw [hP2d] at hP2
  block_init
  step_pure
  step_addressof Edwards25519_basePointPc with bp
  have htb1 : TableAt S.mem bp baseTbl :=
    tableAt_base hbp_room hbp_off (hread_bp.trans (by decide +kernel))
      (fits_entries hbp_fits hbp_fits_168 hbp_fits_336 hbp_fits_504 hbp_fits_672 hbp_fits_840
        hbp_fits_1008 hbp_fits_1176 hbp_fits_1344)
  clear hread_bp hbp_fits hbp_fits_168 hbp_fits_336 hbp_fits_504 hbp_fits_672 hbp_fits_840
    hbp_fits_1008 hbp_fits_1176 hbp_fits_1344 hbp_fits_1512 hbp_fits_1680 hbp_fits_1848
    hbp_fits_2016 hbp_fits_2184 hbp_fits_2352 hbp_fits_2520
  step_pure
  have hbp_ne : bp.id ≠ S.allocaPtr.id := by
    rw [hbp, hS]; slot_ne
  step_addressof Edwards25519_mulDoubleBasePublic_weak.value_eq with wk
  have hwk_room : Room S.mem wk 1408 := by
    rw [hwk]; exact hroom
  have hwb : S.mem.readAt wk 1408 = Edwards25519_mulDoubleBasePublic_weak.bits := by
    rw [hwk]; exact hread.trans (by decide +kernel)
  have hwd : S.mem.definedAt wk 1408 = weakDef := by
    rw [hS, hwk]
    exact
      (MemoryState.definedAt_storeDef_self (InBounds.allocaPtr (by omega)) _ _).trans
        (by decide +kernel)
  clear hread hroom hfits
  step_pure
  have hbp_ne : bp.id ≠ S.allocaPtr.id := by
    rw [hbp, hS]; slot_ne
  have hwk_ne : wk.id ≠ S.allocaPtr.id := by
    rw [hwk, hS]; slot_ne
  step_addressof Edwards25519_identityElement.value_eq with idp
  have hidp_room : Room S.mem idp 1344 := by
    rw [hidp]; exact hroom
  have hidb : S.mem.readAt idp 1344 = Edwards25519.identityBits := by
    rw [hidp]; exact hread.trans (by decide +kernel)
  have hidd : S.mem.definedAt idp 1344 = Edwards25519.identityDef := by
    rw [hS, hidp]
    exact
      (MemoryState.definedAt_storeDef_self (InBounds.allocaPtr (by omega)) _ _).trans
        (by decide +kernel)
  clear hread hroom hfits
  checkpoint hck0
  rename' S => S₁
  iterate 5 step_pure
  step_alloca with t11
  step_alloca with t12
  step_alloca with t13
  step_alloca with t14
  step_alloca with t15
  step_alloca with t16
  step_alloca with t17
  step_alloca with acc
  step_alloca with e2
  step_alloca with e1
  step_alloca with pc
  have hz (t : Pointer) (h : S.mem[t.id]? = some ⟨168, 0, 0, true, fun _ => none⟩) :
    S.mem.PadClear t :=
    .of_fresh (by simp [MemoryState.readAt, h]) (by simp [MemoryState.definedAt, h])
  have hc11 := hz t11 (by fresh_slot ht11)
  have hc12 := hz t12 (by fresh_slot ht12)
  have hc13 := hz t13 (by fresh_slot ht13)
  have hc14 := hz t14 (by fresh_slot ht14)
  have hc15 := hz t15 (by fresh_slot ht15)
  have hc16 := hz t16 (by fresh_slot ht16)
  have hc17 := hz t17 (by fresh_slot ht17)
  have hcacc := hz acc (by fresh_slot hacc)
  clear hz
  have hbase : Fits S.mem (p2.add 160#64) 1 := hp2.fits_base
  have hbr' : S.mem.readAt (p2.add 160#64) 1 = b := hb
  step_pure
  step_load only [hbr'] consuming hbase hbr'
  have h3 : S₁.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 3 := by
    rw [← hck0]; simp [GlobalState.alloca]
  have hL (tb : Pointer) (htb : tb = S₀.slot 0 ∨ tb = S₁.slot 10) :
    Layout ⟨t11, t12, t13, t14, t15, t16, t17, acc, e2, e1, bp, tb⟩ S₀.alloc.nextFreeBlock := by
    rw [ht11, ht12, ht13, ht14, ht15, ht16, ht17, hacc, he2, he1, hbp]
    exact layout_of_slots h3 tb htb
  finish_block
  case isTrue =>
    rw [hbr] at hRes hk
    simp only [spec, blocks, ↓reduceIte] at hRes hk
    have hEr : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
      rw [hS, ← hck0]; erase_frame
    have hAl : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 14 := by
      rw [hS, ← hck0]; simp [GlobalState.alloca]
    refine
      from_bb2 _ _ (hL bp (.inl hbp)) x1 x2 baseTbl baseTbl_lt baseTbl_lt (digit_bound hm1)
        (digit_bound hm2) hm1 hm2 out s1 p2 s2 idp _ _ S E hArgs (by env_reads) (by env_reads) hwf
        (by temps_facts) he1_room he1_off he2_room he2_off hs1 hs1o hx1 hs2 hs2o hx2 htb1 htb1
        hidp_room hidb hidd (by slots) (hs2_ne_e1.symm) (by slots) (by slots) (by slots) (by slots)
        (by slots) (by slots) (by slots) (by slots) (by slots)
        fun E' S' hA' hR' hwf' hacc' hQ' hn' he' => ?_
    have hlt : out.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt (Room.mem hout₀)
    refine
      exit_block _ out s1 p2 s2 _ _ _ S' E' hA' hR' hwf' hacc' hQ'
        (Room.congr (getElem?_of_eraseFrom he' hlt) hout) hoo hout_ne_acc fun E'' S'' hS'' => ?_
    block_init
    finish_block
    rw [hS'', ← hRes, ← hk]
    dsimp only
    rw [MemoryState.eraseFrom_storeDef, MemoryState.eraseFrom_storeAt, he', hEr,
      show S'.alloc = ⟨S'.alloc.nextFreeBlock⟩ from rfl, hn', hAl]
    simp only [store]
    rw [show
        S₀.alloc.nextFreeBlock + 14 + 6 + ladderBlocks x1 x2 63 =
          S₀.alloc.nextFreeBlock + (20 + ladderBlocks x1 x2 63)
        by omega]
  case isFalse =>
    simp only [spec, blocks, hbr, ↓reduceIte] at hRes hk
    have hp2l := hp2.ptLimbsFit
    have hP2' : (S.mem.readPt p2).Lt (2 ^ 53) := hP2d ▸ hP2
    have hR2 : (S.mem.readAt p2 1344).extractLsb' 0 1280 = P2.bits := by
      rw [← hP2d]; exact MemoryState.readAt_pt_bits hp2.2.1.inBounds hp2.1
    have hD2 := hp2l.definedAt
    block_init
    checkpoint hckp
    have hT2 :=
      fun m'
        (hm :
          m' =
            S.mem.storeDef pc (Edwards25519.precompute.bits P2 (S.mem.readAt p2 1344))
              (Edwards25519.precompute.defs (S.mem.definedAt p2 1344))) =>
      hm ▸ tableAt_pc hpc_room hpc_off hR2 hD2
    clear hR2 hD2
    step_call using Edwards25519_precompute.call_eq consuming hp2l hP2'
    have htb2 := hT2 _ (congrArg GlobalState.mem hS)
    clear hT2
    obtain ⟨h4f, h4r⟩ := htb2 4 (by omega)
    simp only [Nat.reduceMul] at h4f h4r
    have h4x : Fe.Lt (pcTbl P2 4).x (2 ^ 63) := (pcTbl_lt hP2 4 (by omega)).1.mono (by decide)
    step_pure
    step_call using (Edwards25519_rejectIdentity.call_eq_of (P := pcTbl P2 4)) consuming h4f h4r h4x
    step_pure
    have hEr : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
      rw [hS]; dsimp only; rw [← hckp, ← hck0]; erase_frame
    have hAl : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 245 := by
      rw [hS]; dsimp only; rw [← hckp, ← hck0]; simp [GlobalState.alloca]
    finish_block
    case isTrue =>
      simp only [hbr, ↓reduceIte] at hRes hk
      refine
        from_bb2 _ _ (hL pc (.inr hpc)) x1 x2 (pcTbl P2) baseTbl_lt (pcTbl_lt hP2) (digit_bound hm1)
          (digit_bound hm2) hm1 hm2 out s1 p2 s2 idp _ _ S E hArgs (by env_reads) (by env_reads) hwf
          (by temps_facts) he1_room he1_off he2_room he2_off hs1 hs1o hx1 hs2 hs2o hx2 htb1 htb2
          hidp_room hidb hidd (by slots) (hs2_ne_e1.symm) (by slots) (by slots) (by slots)
          (by slots) (by slots) (by slots) (by slots) (by slots) (by slots)
          fun E' S' hA' hR' hwf' hacc' hQ' hn' he' => ?_
      have hlt : out.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt (Room.mem hout₀)
      refine
        exit_block _ out s1 p2 s2 _ _ _ S' E' hA' hR' hwf' hacc' hQ'
          (Room.congr (getElem?_of_eraseFrom he' hlt) hout) hoo hout_ne_acc fun E'' S'' hS'' => ?_
      block_init
      finish_block
      rw [hS'', ← hRes, ← hk]
      dsimp only
      rw [MemoryState.eraseFrom_storeDef, MemoryState.eraseFrom_storeAt, he', hEr,
        show S'.alloc = ⟨S'.alloc.nextFreeBlock⟩ from rfl, hn', hAl]
      simp only [store]
      rw [show
          S₀.alloc.nextFreeBlock + 245 + 6 + ladderBlocks x1 x2 63 =
            S₀.alloc.nextFreeBlock + (251 + ladderBlocks x1 x2 63)
          by omega]
    case isFalse =>
      simp only [hbr, ↓reduceIte] at hRes hk
      have hout_ne_wk : out.id ≠ wk.id := by
        have := hwf₀.lt (Room.mem hout₀)
        rw [hwk]; intro h; simp only [GlobalState.slot] at h; rw [h] at this; simp at this
      refine
        weak_block out s1 p2 s2 wk _ _ S E hArgs (by env_reads) hwf hout hwk_room hout_ne_wk hwb hwd
          fun E' S' hS' => ?_
      block_init
      finish_block
      rw [hS', ← hRes, ← hk]
      dsimp only
      rw [MemoryState.eraseFrom_storeDef, hEr, show S.alloc = ⟨S.alloc.nextFreeBlock⟩ from rfl, hAl]
      rfl

end Proof

end MLIR.Zig
