module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.Globals
public import Zig.Edwards25519_add
public import Zig.Edwards25519_dbl
public import Zig.Mlir.Edwards25519_precompute
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide
import Mathlib.Tactic.Rename

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `precompute(P, 8)`'s entries: entry `i` is `dbl` of entry `i / 2` for even `i ≥ 2`, `add` of
entry `i - 1` and `P` for odd `i ≥ 3`. -/
def Edwards25519.precompute.spec (P : ZPt) : Vector ZPt 9 :=
  let p2 := Edwards25519.dbl.spec P
  let p3 := Edwards25519.add.spec p2 P
  let p4 := Edwards25519.dbl.spec p2
  let p5 := Edwards25519.add.spec p4 P
  let p6 := Edwards25519.dbl.spec p3
  let p7 := Edwards25519.add.spec p6 P
  let p8 := Edwards25519.dbl.spec p4
  #v[Edwards25519.identity, P, p2, p3, p4, p5, p6, p7, p8]

/-- The identity global's definedness: its point's bits and `is_base`'s, not the padding. -/
def Edwards25519.identityDef : BitVec 1344 :=
  (Ty.flattenDef EdTy (Edwards25519.identity.val 0)).2.cast (by decide)

/-- The table's 1512 bytes, entry `i` at byte `168 i`: the identity global's, then `r` (`P`'s
bytes), then the entries as fresh slots hold them. -/
def Edwards25519.precompute.bits (P : ZPt) (r : BitVec 1344) : BitVec 12096 :=
  BitVec.packLanes
    (Vector.ofFn fun i : Fin 9 =>
      if i.val = 0 then Edwards25519.identityBits
      else if i.val = 1 then r else (Edwards25519.precompute.spec P)[i].raw 0)

/-- Which of them are defined: the identity's, `d` (`P`'s), then all but the padding. -/
def Edwards25519.precompute.defs (d : BitVec 1344) : BitVec 12096 :=
  BitVec.packLanes
    (Vector.ofFn fun i : Fin 9 =>
      if i.val = 0 then Edwards25519.identityDef else if i.val = 1 then d else ZPt.rawDef)

end

set_option exponentiation.threshold 1344 in
public theorem identityBits_low :
    Edwards25519.identityBits.extractLsb' 0 1280 = Edwards25519.identity.bits := by decide +kernel

set_option exponentiation.threshold 1344 in
public theorem identityDef_low :
    Edwards25519.identityDef.extractLsb' 0 1280 = BitVec.allOnes 1280 := by decide +kernel

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `hS` kept reversed as `hck`: later states build on an opaque `S`. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

set_option hygiene false in
/-- Before a copy into entry `j`: `hS` checkpointed, the table facts `hA`, `hD` kept as `hT` for any
copied bits and pointers. -/
local macro "tbl_pre " j:num : tactic =>
  `(tactic|
    ( checkpoint hck
      have hT := fun x d P (m' : MemoryState) hm =>
        tbl_storeCopy (m' := m') hc_room hc_off hA hD (j := $j) (by omega) x d P hm
      have hdst :=
        Room.add_of_le (entry_ov hc_off (j := $j) (by omega)).2
          (by
            have := (entry_ov hc_off (j := $j) (by omega)).1; omega)
          (w := 1344) hc_room
      simp only [Nat.reduceMul, Pointer.add_zero] at hT hdst
      clear hA hD))

set_option hygiene false in
/-- After a copy of `x`, defined `d`, into an entry (a copy of no pointers as one): `hT`'s table
facts, as `hA`, `hD` on `S`. -/
local macro "tbl_post " x:term:max d:term:max : tactic =>
  `(tactic|
    ( have hSc := hS
      try rw [← MemoryState.storeCopy_none] at hSc
      obtain ⟨hA, hD⟩ := hT $x $d _ S.mem (congrArg GlobalState.mem hSc)
      clear hSc
      have hcr : Room S.mem c 12096 ∧ PtrFree S.mem c 12096 := ⟨hc_room, hcF⟩
      clear hT
      clear_facts c
      have hc_room := hcr.1
      have hcF := hcr.2
      clear hcr))

set_option hygiene false in
/-- Entry `j`'s facts, the point `Q`: room, field elements known, `Q` read. -/
local macro "entry " j:num Q:term:max : tactic =>
  `(tactic|
    ( obtain ⟨hER, hEb, hEd⟩ := tbl_entry hc_room hc_off hA hD (j := $j) (by omega)
      have hEf :=
        MemoryState.PtLimbsFit.of_definedAt hER.ptLive
          (by
            rw [hEd];
            simp only [Vector.getElem_set, Vector.getElem_replicate, Nat.reduceEqDiff, ↓reduceIte]
            first
            | exact hD₁
            | exact identityDef_low
            | exact ZPt.rawDef_low)
      have hEp : S.mem.readPt _ = $Q :=
        MemoryState.readPt_of_readAt (hER.2.inBounds.mono (by omega)) hER.1
          ((MemoryState.readAt_of_readAt_le (by omega) hEb).trans
            (by
              rw [BitVec.setWidth_eq_extractLsb' (by omega)]
              simp only [Vector.getElem_set, Vector.getElem_replicate, Nat.reduceEqDiff, ↓reduceIte]
              first
              | exact hR₁
              | exact identityBits_low
              | exact ZPt.over_bits _ _ _))
      simp only [Nat.reduceMul] at hER hEf hEp
      clear hEb hEd))

set_option hygiene false in
/-- The counter's `+ 1` from `i`, then the loop head and the parity test, into `i + 1`'s branch. -/
local macro "next_iter " i:num : tactic =>
  `(tactic|
    ( step_pure [show (BitVec.ofNat 64 $i).saddOverflow 1#64 = false by decide,
        show (BitVec.ofNat 64 $i).uaddOverflow 1#64 = false by decide]
      finish_block
      block_init
      step_pure
      finish_block
      block_init
      iterate 3 step_pure
      finish_block
      block_init))

/-- Bit `m` of nine packed points: bit `m % 1344` of lane `m / 1344`. -/
theorem getLsbD_packLanes9 (v : Vector (BitVec 1344) 9) {m : Nat} (hm : m < 1344 * 9) :
    (BitVec.packLanes v).getLsbD m = (v[m / 1344]'(by omega)).getLsbD (m % 1344) := by
  have h := BitVec.extractLsb'_packLanes_of_lt v (s := m) (w := 1) (by omega) (by omega)
  simpa [BitVec.getLsbD_extractLsb'] using congrArg (·.getLsbD 0) h

/-- Nine zero lanes are zero. -/
theorem packLanes_zero : BitVec.packLanes (Vector.replicate 9 (0#1344)) = 0#12096 := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  rw [getLsbD_packLanes9 _ hm]
  simp

/-- Splicing lane `j` into nine packed points sets it. -/
theorem spliceBits_packLanes9 {u : Vector (BitVec 1344) 9} (hj : j < 9) (y : BitVec 1344) :
    Memory.spliceBits (BitVec.packLanes u) (j * 1344) y = BitVec.packLanes (u.set j y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  rw [Memory.getLsbD_spliceBits, getLsbD_packLanes9 _ hm, getLsbD_packLanes9 _ hm,
    Vector.getElem_set]
  by_cases h : m / 1344 = j
  · subst h
    have hc : m / 1344 * 1344 ≤ m ∧ m < m / 1344 * 1344 + 1344 ∧ m < 1344 * 9 := by omega
    simp only [hc, and_self, ite_true]
    congr 1
    omega
  · have hc : ¬(j * 1344 ≤ m ∧ m < j * 1344 + 1344 ∧ m < 1344 * 9) := by omega
    simp only [hc, ite_false, Ne.symm h]

/-- Entry `j`'s offset, which does not wrap from a block's start. -/
theorem entry_ov {c : Pointer} (ho : c.offset = 0) (hj : j < 9) :
    (BitVec.ofNat 64 (j * 168)).toNat = j * 168 ∧
      ¬c.offset.uaddOverflow (BitVec.ofNat 64 (j * 168)) := by
  have hj' : (BitVec.ofNat 64 (j * 168)).toNat = j * 168 := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨hj', ?_⟩
  simp only [BitVec.uaddOverflow, ho, hj', decide_eq_true_eq,
    show (0 : BitVec 64).toNat = 0 from rfl]
  omega

/-- A read over a masked store inside it: the bits read before, the stored ones spliced in. -/
theorem readAt_add_storeDef {m : MemoryState} {p : Pointer} {off : BitVec 64} (h : Room m p v)
    (hov : ¬p.offset.uaddOverflow off) (_hw : off.toNat * 8 + w ≤ v) (x d : BitVec w) :
    (m.storeDef (p.add off) x d).readAt p v =
      Memory.spliceBits (m.readAt p v) (off.toNat * 8) x := by
  obtain ⟨blk, hblk, -, hsz, hwr⟩ := h.block
  have hs := MemoryState.getElem?_storeDef_self (p := p.add off) (x := x) (d := d) hblk hwr
  simp only [Pointer.add_id] at hs
  simp only [MemoryState.readAt, hs, hblk]
  unfold MemoryBlock.lengthInBits at hsz
  rw [Pointer.offsetInBits_add hov]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', Memory.getLsbD_spliceBits]
  grind

/-- Definedness over a masked store inside it: `d` spliced in. -/
theorem definedAt_add_storeDef {m : MemoryState} {p : Pointer} {off : BitVec 64}
    (h : Room m p v) (hov : ¬p.offset.uaddOverflow off) (_hw : off.toNat * 8 + w ≤ v)
    (x d : BitVec w) :
    (m.storeDef (p.add off) x d).definedAt p v =
      Memory.spliceBits (m.definedAt p v) (off.toNat * 8) d := by
  obtain ⟨blk, hblk, -, hsz, hwr⟩ := h.block
  have hs := MemoryState.getElem?_storeDef_self (p := p.add off) (x := x) (d := d) hblk hwr
  simp only [Pointer.add_id] at hs
  simp only [MemoryState.definedAt, hs, hblk]
  unfold MemoryBlock.lengthInBits at hsz
  rw [Pointer.offsetInBits_add hov]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', Memory.getLsbD_spliceBits]
  grind

/-- A copy into entry `j` of the table at `c`: lane `j` set, in the bits and their definedness. -/
theorem tbl_storeDef {m m' : MemoryState} {c : Pointer} {v dv : Vector (BitVec 1344) 9}
    (hf : Room m c 12096) (ho : c.offset = 0) (hA : m.readAt c 12096 = BitVec.packLanes v)
    (hD : m.definedAt c 12096 = BitVec.packLanes dv) (hj : j < 9) (x d : BitVec 1344)
    (hm : m' = m.storeDef (c.add (BitVec.ofNat 64 (j * 168))) x d) :
    m'.readAt c 12096 = BitVec.packLanes (v.set j x) ∧
      m'.definedAt c 12096 = BitVec.packLanes (dv.set j d) := by
  subst hm
  have hw : (BitVec.ofNat 64 (j * 168)).toNat * 8 + 1344 ≤ 12096 := by
    rw [(entry_ov ho hj).1]; omega
  rw [readAt_add_storeDef hf (entry_ov ho hj).2 hw, definedAt_add_storeDef hf (entry_ov ho hj).2 hw,
    hA, hD, (entry_ov ho hj).1, show j * 168 * 8 = j * 1344 by omega, spliceBits_packLanes9 hj,
    spliceBits_packLanes9 hj]
  exact ⟨rfl, rfl⟩

/-- `tbl_storeDef` for a copy carrying pointers `P`. -/
theorem tbl_storeCopy {m m' : MemoryState} {c : Pointer} {v dv : Vector (BitVec 1344) 9}
    (hf : Room m c 12096) (ho : c.offset = 0) (hA : m.readAt c 12096 = BitVec.packLanes v)
    (hD : m.definedAt c 12096 = BitVec.packLanes dv) (hj : j < 9) (x d : BitVec 1344)
    (P : Nat → Option Pointer) (hm : m' = m.storeCopy (c.add (BitVec.ofNat 64 (j * 168))) x d P) :
    m'.readAt c 12096 = BitVec.packLanes (v.set j x) ∧
      m'.definedAt c 12096 = BitVec.packLanes (dv.set j d) := by
  subst hm
  rw [MemoryState.sameBits_storeCopy.readAt, MemoryState.sameBits_storeCopy.definedAt]
  exact tbl_storeDef hf ho hA hD hj x d rfl

/-- Entry `j` of the table at `c`: lane `j`'s bits and definedness. -/
theorem tbl_entry {m : MemoryState} {c : Pointer} {v dv : Vector (BitVec 1344) 9}
    (hf : Room m c 12096) (ho : c.offset = 0) (hA : m.readAt c 12096 = BitVec.packLanes v)
    (hD : m.definedAt c 12096 = BitVec.packLanes dv) (hj : j < 9) :
    m.PtRoom (c.add (BitVec.ofNat 64 (j * 168))) ∧
      m.readAt (c.add (BitVec.ofNat 64 (j * 168))) 1344 = v[j] ∧
      m.definedAt (c.add (BitVec.ofNat 64 (j * 168))) 1344 = dv[j] := by
  have hw : (BitVec.ofNat 64 (j * 168)).toNat * 8 + 1344 ≤ 12096 := by
    rw [(entry_ov ho hj).1]; omega
  have hoff : (c.add (BitVec.ofNat 64 (j * 168))).offsetInBits = j * 1344 := by
    rw [Pointer.offsetInBits_add (entry_ov ho hj).2, (entry_ov ho hj).1]
    simp [Pointer.offsetInBits, ho]; omega
  refine ⟨⟨?_, Room.add_of_le (entry_ov ho hj).2 hw hf⟩, ?_, ?_⟩
  · simp only [Pointer.add, BitVec.toNat_add, (entry_ov ho hj).1, ho,
      show (0 : BitVec 64).toNat = 0 from rfl]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  · rw [MemoryState.readAt_add_of_readAt hf.inBounds (entry_ov ho hj).2 hw hA, (entry_ov ho hj).1,
      show j * 168 * 8 = j * 1344 by omega, BitVec.extractLsb'_packLanes _ _ hj]
  · obtain ⟨blk, hblk, -, hsz, -⟩ := hf.block
    have hb : m[(c.add (BitVec.ofNat 64 (j * 168))).id]? = some blk := hblk
    have hD' := hD
    simp only [MemoryState.definedAt, hblk] at hD'
    simp only [MemoryState.definedAt, hb, hoff]
    rw [show c.offsetInBits = 0 by simp [Pointer.offsetInBits, ho]] at hD'
    have := congrArg (·.extractLsb' (j * 1344) 1344) hD'
    simp only [BitVec.extractLsb'_extractLsb'_add (show j * 1344 + 1344 ≤ 12096 by omega),
      Nat.zero_add] at this
    rw [this, BitVec.extractLsb'_packLanes _ _ hj]

/-- The table the steps build: `bits`. -/
theorem precompute_bits_eq (P : ZPt) (R : BitVec 1344) :
    BitVec.packLanes
        ((((((((((Vector.replicate 9 0#1344).set 0 Edwards25519.identityBits (by decide)).set 1 R
                                      (by decide)).set
                                  2 ((Edwards25519.dbl.spec P).raw 0#1) (by decide)).set
                              3 ((Edwards25519.add.spec (Edwards25519.dbl.spec P) P).raw 0#1)
                              (by decide)).set
                          4 ((Edwards25519.dbl.spec (Edwards25519.dbl.spec P)).raw 0#1)
                          (by decide)).set
                      5
                      ((Edwards25519.add.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P))
                            P).raw
                        0#1)
                      (by decide)).set
                  6
                  ((Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)).raw
                    0#1)
                  (by decide)).set
              7
              ((Edwards25519.add.spec
                    (Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P))
                    P).raw
                0#1)
              (by decide)).set
          8 ((Edwards25519.dbl.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P))).raw 0#1)
          (by decide)) =
      Edwards25519.precompute.bits P R := by
  unfold Edwards25519.precompute.bits
  rfl

/-- Its definedness: `defs`. -/
theorem precompute_defs_eq (D : BitVec 1344) :
    BitVec.packLanes
        ((((((((((Vector.replicate 9 0#1344).set 0 Edwards25519.identityDef (by decide)).set 1 D
                                      (by decide)).set
                                  2 ZPt.rawDef (by decide)).set
                              3 ZPt.rawDef (by decide)).set
                          4 ZPt.rawDef (by decide)).set
                      5 ZPt.rawDef (by decide)).set
                  6 ZPt.rawDef (by decide)).set
              7 ZPt.rawDef (by decide)).set
          8 ZPt.rawDef (by decide)) =
      Edwards25519.precompute.defs D := by
  unfold Edwards25519.precompute.defs
  rfl

-- nine entries, seven calls in four blocks, each step carrying the facts
set_option maxHeartbeats 3000000 in
/-- `Edwards25519.precompute` copies the table of `spec P` to `out`: entry `0` the identity global's
bytes, `1` `p`'s, the others as fresh slots hold them; for limbs below `2^53`. -/
public theorem Edwards25519_precompute.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Edwards25519_precompute.globals)
    (hout : Room s.mem out 12096) (hp : s.mem.PtFit p) (hP : (s.mem.readPt p).Lt (2 ^ 53)) :
    Edwards25519_precompute.call (Edwards25519_precompute.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 226⟩,
            mem :=
              s.mem.storeDef out
                (Edwards25519.precompute.bits (s.mem.readPt p) (s.mem.readAt p 1344))
                (Edwards25519.precompute.defs (s.mem.definedAt p 1344)) }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hP
  generalize hRd : S.mem.readAt p 1344 = R
  generalize hDd : S.mem.definedAt p 1344 = D
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  have hR₀ : S₀.mem.readAt p 1344 = R := hS ▸ hRd
  have hD₀ : S₀.mem.definedAt p 1344 = D := hS ▸ hDd
  rw [hP₀, hR₀, hD₀]
  block_init
  step_pure
  step_addressof Edwards25519_identityElement.value_eq with g
  have hgb : S.mem.readAt g 1344 = Edwards25519.identityBits := hread_g.trans (by decide +kernel)
  have hgd : S.mem.definedAt g 1344 = Edwards25519.identityDef :=
    hdefined_g.trans (by decide +kernel)
  clear hread_g hdefined_g
  checkpoint hck0
  rename' S => S₁
  iterate 7 step_pure
  step_alloca with t9
  step_alloca with t10
  step_alloca with c
  have ht9R := MemoryState.PtRoom.of_room ht9_room ht9_off
  have ht10R := MemoryState.PtRoom.of_room ht10_room ht10_off
  -- the slots are fresh
  have hne (a b : Nat) (hab : a ≠ b) : (S₁.slot a).id ≠ (S₁.slot b).id := GlobalState.slot_id_ne hab
  have ht9c : S.mem.PadClear t9 := by
    have h : S.mem[t9.id]? = (S₁.alloca 168).mem[S₁.allocaPtr.id]? := by
      rw [hS, ht9, ← GlobalState.allocaPtr_eq_slot]
      rw [GlobalState.getElem?_alloca
          (by
            simp [GlobalState.allocaPtr, GlobalState.alloca]; omega),
        GlobalState.getElem?_alloca (by simp [GlobalState.allocaPtr, GlobalState.alloca])]
    rw [ht9, ← GlobalState.allocaPtr_eq_slot] at h ⊢
    exact
      .of_fresh ((readAt_congr h).trans MemoryState.readAt_alloca_allocaPtr)
        ((definedAt_congr h).trans MemoryState.definedAt_alloca_allocaPtr)
  have ht10c : S.mem.PadClear t10 := by
    have e : S₁.slot 1 = (S₁.alloca 168).allocaPtr := by
      rw [GlobalState.allocaPtr_eq_slot, GlobalState.alloca_slot]
    have h : S.mem[t10.id]? = ((S₁.alloca 168).alloca 168).mem[(S₁.alloca 168).allocaPtr.id]? := by
      rw [hS, ht10, e]
      rw [GlobalState.getElem?_alloca (by simp [GlobalState.allocaPtr, GlobalState.alloca])]
    rw [ht10, e] at h ⊢
    exact
      .of_fresh ((readAt_congr h).trans MemoryState.readAt_alloca_allocaPtr)
        ((definedAt_congr h).trans MemoryState.definedAt_alloca_allocaPtr)
  clear hne
  have hcp : c = ((S₁.alloca 168).alloca 168).allocaPtr := by
    rw [hc, GlobalState.allocaPtr_eq_slot, GlobalState.alloca_slot, GlobalState.alloca_slot]
  have hA : S.mem.readAt c 12096 = BitVec.packLanes (Vector.replicate 9 0#1344) := by
    rw [packLanes_zero, hS, hcp]; exact MemoryState.readAt_alloca_allocaPtr
  have hD : S.mem.definedAt c 12096 = BitVec.packLanes (Vector.replicate 9 0#1344) := by
    rw [packLanes_zero, hS, hcp]; exact MemoryState.definedAt_alloca_allocaPtr
  -- no pointer in the table: its copy to `out` carries none
  have hcF : PtrFree S.mem c 12096 := by rw [hS, hcp]; exact PtrFree.allocaPtr
  clear hcp
  have hR₁ : R.extractLsb' 0 1280 = P.bits := by
    rw [← hRd, ← hPd]; exact MemoryState.readAt_pt_bits hp.2.1.inBounds hp.1
  have hD₁ : D.extractLsb' 0 1280 = BitVec.allOnes 1280 := by
    rw [← hDd]; exact hp.ptLimbsFit.definedAt
  -- entry 0: the identity global's bytes
  tbl_pre 0
  step_memcpy
  tbl_post Edwards25519.identityBits Edwards25519.identityDef
  -- entry 1: `p`'s
  step_pure
  tbl_pre 1
  step_memcpy
  tbl_post R D
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  iterate 3 step_pure
  finish_block
  block_init
  -- 2: dbl of entry 1
  iterate 2 step_pure
  entry 1P
  have hX := hP.1
  have hY := hP.2.1
  have hZ := hP.2.2.1
  have hR10 := hS ▸ (show S.mem.PtRoom t10 by mem_fact)
  have hC10 := hS ▸ ht10c
  clear ht10c
  step_call using Edwards25519_dbl.call_eq_of consuming hEf hEp hX hY hZ
  have hT10 : S.mem.readAt t10 1344 = (Edwards25519.dbl.spec P).raw 0 := by
    rw [hS]; exact MemoryState.readAt_storePt_padClear hR10 hC10
  have hT10d : S.mem.definedAt t10 1344 = ZPt.rawDef := by
    rw [hS]; exact MemoryState.definedAt_storePt_padClear hR10 hC10
  have ht10c : S.mem.PadClear t10 := by
    rw [hS]; exact .storePt_self hR10 hC10
  clear hR10 hC10 hER
  finish_block
  block_init
  tbl_pre 2
  step_memcpy consuming hT10 hT10d hdst
  tbl_post ((Edwards25519.dbl.spec P).raw 0)ZPt.rawDef
  next_iter 2
  -- 3: entry 2 plus `P`
  step_pure [show (3#64).saddOverflow 18446744073709551615#64 = false by decide]
  step_pure
  entry 2(Edwards25519.dbl.spec P)
  have hB : (Edwards25519.dbl.spec P).Lt (2 ^ 53) := (Edwards25519.dbl.spec_lt _).mono53
  have hR9 := hS ▸ (show S.mem.PtRoom t9 by mem_fact)
  have hC9 := hS ▸ ht9c
  clear ht9c
  step_call using Edwards25519_add.call_eq_of consuming hEf hEp hB
  have hT9 : S.mem.readAt t9 1344 = (Edwards25519.add.spec (Edwards25519.dbl.spec P) P).raw 0 := by
    rw [hS]; exact MemoryState.readAt_storePt_padClear hR9 hC9
  have hT9d : S.mem.definedAt t9 1344 = ZPt.rawDef := by
    rw [hS]; exact MemoryState.definedAt_storePt_padClear hR9 hC9
  have ht9c : S.mem.PadClear t9 := by
    rw [hS]; exact .storePt_self hR9 hC9
  clear hR9 hC9 hER
  finish_block
  block_init
  tbl_pre 3
  step_memcpy consuming hT9 hT9d hdst
  tbl_post ((Edwards25519.add.spec (Edwards25519.dbl.spec P) P).raw 0)ZPt.rawDef
  next_iter 3
  -- 4: dbl of entry 2
  iterate 2 step_pure
  entry 2(Edwards25519.dbl.spec P)
  have hB := (Edwards25519.dbl.spec_lt _).mono53 (P := (Edwards25519.dbl.spec P))
  have hX := hB.1
  have hY := hB.2.1
  have hZ := hB.2.2.1
  clear hB
  have hR10 := hS ▸ (show S.mem.PtRoom t10 by mem_fact)
  have hC10 := hS ▸ ht10c
  clear ht10c
  step_call using Edwards25519_dbl.call_eq_of consuming hEf hEp hX hY hZ
  have hT10 : S.mem.readAt t10 1344 = (Edwards25519.dbl.spec (Edwards25519.dbl.spec P)).raw 0 := by
    rw [hS]; exact MemoryState.readAt_storePt_padClear hR10 hC10
  have hT10d : S.mem.definedAt t10 1344 = ZPt.rawDef := by
    rw [hS]; exact MemoryState.definedAt_storePt_padClear hR10 hC10
  have ht10c : S.mem.PadClear t10 := by
    rw [hS]; exact .storePt_self hR10 hC10
  clear hR10 hC10 hER
  finish_block
  block_init
  tbl_pre 4
  step_memcpy consuming hT10 hT10d hdst
  tbl_post ((Edwards25519.dbl.spec (Edwards25519.dbl.spec P)).raw 0)ZPt.rawDef
  next_iter 4
  -- 5: entry 4 plus `P`
  step_pure [show (5#64).saddOverflow 18446744073709551615#64 = false by decide]
  step_pure
  entry 4(Edwards25519.dbl.spec (Edwards25519.dbl.spec P))
  have hB : (Edwards25519.dbl.spec (Edwards25519.dbl.spec P)).Lt (2 ^ 53) :=
    (Edwards25519.dbl.spec_lt _).mono53
  have hR9 := hS ▸ (show S.mem.PtRoom t9 by mem_fact)
  have hC9 := hS ▸ ht9c
  clear ht9c
  step_call using Edwards25519_add.call_eq_of consuming hEf hEp hB
  have hT9 :
    S.mem.readAt t9 1344 =
      (Edwards25519.add.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P)) P).raw 0 := by
    rw [hS]; exact MemoryState.readAt_storePt_padClear hR9 hC9
  have hT9d : S.mem.definedAt t9 1344 = ZPt.rawDef := by
    rw [hS]; exact MemoryState.definedAt_storePt_padClear hR9 hC9
  have ht9c : S.mem.PadClear t9 := by
    rw [hS]; exact .storePt_self hR9 hC9
  clear hR9 hC9 hER
  finish_block
  block_init
  tbl_pre 5
  step_memcpy consuming hT9 hT9d hdst
  tbl_post
    ((Edwards25519.add.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P)) P).raw 0)ZPt.rawDef
  next_iter 5
  -- 6: dbl of entry 3
  iterate 2 step_pure
  entry 3(Edwards25519.add.spec (Edwards25519.dbl.spec P) P)
  have hB :=
    (Edwards25519.add.spec_lt _ _).mono53 (P := (Edwards25519.add.spec (Edwards25519.dbl.spec P) P))
  have hX := hB.1
  have hY := hB.2.1
  have hZ := hB.2.2.1
  clear hB
  have hR10 := hS ▸ (show S.mem.PtRoom t10 by mem_fact)
  have hC10 := hS ▸ ht10c
  clear ht10c
  step_call using Edwards25519_dbl.call_eq_of consuming hEf hEp hX hY hZ
  have hT10 :
    S.mem.readAt t10 1344 =
      (Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)).raw 0 := by
    rw [hS]; exact MemoryState.readAt_storePt_padClear hR10 hC10
  have hT10d : S.mem.definedAt t10 1344 = ZPt.rawDef := by
    rw [hS]; exact MemoryState.definedAt_storePt_padClear hR10 hC10
  have ht10c : S.mem.PadClear t10 := by
    rw [hS]; exact .storePt_self hR10 hC10
  clear hR10 hC10 hER
  finish_block
  block_init
  tbl_pre 6
  step_memcpy consuming hT10 hT10d hdst
  tbl_post
    ((Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)).raw 0)ZPt.rawDef
  next_iter 6
  -- 7: entry 6 plus `P`
  step_pure [show (7#64).saddOverflow 18446744073709551615#64 = false by decide]
  step_pure
  entry 6(Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P))
  have hB :
    (Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)).Lt (2 ^ 53) :=
    (Edwards25519.dbl.spec_lt _).mono53
  have hR9 := hS ▸ (show S.mem.PtRoom t9 by mem_fact)
  have hC9 := hS ▸ ht9c
  clear ht9c
  step_call using Edwards25519_add.call_eq_of consuming hEf hEp hB
  have hT9 :
    S.mem.readAt t9 1344 =
      (Edwards25519.add.spec
            (Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)) P).raw
        0 := by
    rw [hS]; exact MemoryState.readAt_storePt_padClear hR9 hC9
  have hT9d : S.mem.definedAt t9 1344 = ZPt.rawDef := by
    rw [hS]; exact MemoryState.definedAt_storePt_padClear hR9 hC9
  have ht9c : S.mem.PadClear t9 := by
    rw [hS]; exact .storePt_self hR9 hC9
  clear hR9 hC9 hER
  finish_block
  block_init
  tbl_pre 7
  step_memcpy consuming hT9 hT9d hdst
  tbl_post
    ((Edwards25519.add.spec
          (Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)) P).raw
      0)ZPt.rawDef
  next_iter 7
  -- 8: dbl of entry 4
  iterate 2 step_pure
  entry 4(Edwards25519.dbl.spec (Edwards25519.dbl.spec P))
  have hB :=
    (Edwards25519.dbl.spec_lt _).mono53 (P := (Edwards25519.dbl.spec (Edwards25519.dbl.spec P)))
  have hX := hB.1
  have hY := hB.2.1
  have hZ := hB.2.2.1
  clear hB
  have hR10 := hS ▸ (show S.mem.PtRoom t10 by mem_fact)
  have hC10 := hS ▸ ht10c
  clear ht10c
  step_call using Edwards25519_dbl.call_eq_of consuming hEf hEp hX hY hZ
  have hT10 :
    S.mem.readAt t10 1344 =
      (Edwards25519.dbl.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P))).raw 0 := by
    rw [hS]; exact MemoryState.readAt_storePt_padClear hR10 hC10
  have hT10d : S.mem.definedAt t10 1344 = ZPt.rawDef := by
    rw [hS]; exact MemoryState.definedAt_storePt_padClear hR10 hC10
  have ht10c : S.mem.PadClear t10 := by
    rw [hS]; exact .storePt_self hR10 hC10
  clear hR10 hC10 hER
  finish_block
  block_init
  tbl_pre 8
  step_memcpy consuming hT10 hT10d hdst
  tbl_post
    ((Edwards25519.dbl.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P))).raw 0)ZPt.rawDef
  step_pure [show (8#64).saddOverflow 1#64 = false by decide,
    show (8#64).uaddOverflow 1#64 = false by decide]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_memcpy consuming hp hPd hRd hDd
  finish_block
  rw [hS]
  clear hS hwf
  subst_vars
  erase_frame
  rw [precompute_bits_eq, precompute_defs_eq]
  rfl

end Proof

end MLIR.Zig
