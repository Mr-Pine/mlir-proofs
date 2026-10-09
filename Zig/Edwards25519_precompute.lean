module

public import MLIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
public import Zig.Point
public import Zig.Edwards25519_add
public import Zig.Edwards25519_dbl
public import Zig.Edwards25519_identityElement
public import Zig.Mlir.Edwards25519_precompute
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide

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

/-- The table's 1512 bytes: entry `i` at byte `168 i`, entry `1`'s last 8 bytes `r`, the others'
zero. -/
def Edwards25519.precompute.bits (P : ZPt) (r : BitVec 64) : BitVec 12096 :=
  BitVec.packLanes
    (Vector.ofFn fun i : Fin 9 =>
      (Edwards25519.precompute.spec P)[i].bits (if i.val = 1 then r else 0#64))

end

/-! ## Proof -/

section Proof

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
    (BitVec.ofNat 64 (168 * j)).toNat = 168 * j ∧
      ¬c.offset.uaddOverflow (BitVec.ofNat 64 (168 * j)) := by
  have hj' : (BitVec.ofNat 64 (168 * j)).toNat = 168 * j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨hj', ?_⟩
  simp only [BitVec.uaddOverflow, ho, hj', decide_eq_true_eq,
    show (0 : BitVec 64).toNat = 0 from rfl]
  omega

/-- A store of entry `j` into the table at `c`: lane `j` set. -/
theorem readAt_tbl_storeAt {m : MemoryState} {c : Pointer} {v : Vector (BitVec 1344) 9}
    (hf : Fits m c 12096) (ho : c.offset = 0) (hA : m.readAt c 12096 = BitVec.packLanes v)
    (hj : j < 9) (x : BitVec 1344) :
    (m.storeAt (c.add (BitVec.ofNat 64 (168 * j))) x).readAt c 12096 =
      BitVec.packLanes (v.set j x) := by
  rw [MemoryState.readAt_add_storeAt hf (entry_ov ho hj).2
      (by
        rw [(entry_ov ho hj).1]; omega),
    hA, (entry_ov ho hj).1, show 168 * j * 8 = j * 1344 by omega, spliceBits_packLanes9 hj]

/-- Entry `j` of the table at `c`: lane `j`, a point that fits. -/
theorem readAt_tbl {m : MemoryState} {c : Pointer} {v : Vector (BitVec 1344) 9}
    (hf : Fits m c 12096) (ho : c.offset = 0) (hA : m.readAt c 12096 = BitVec.packLanes v)
    (hj : j < 9) :
    m.PtFit (c.add (BitVec.ofNat 64 (168 * j))) ∧
      m.readAt (c.add (BitVec.ofNat 64 (168 * j))) 1344 = v[j] := by
  have hw : (BitVec.ofNat 64 (168 * j)).toNat * 8 + 1344 ≤ 12096 := by
    rw [(entry_ov ho hj).1]; omega
  refine ⟨⟨?_, Fits.add_of_le (entry_ov ho hj).2 hw hf⟩, ?_⟩
  · simp only [Pointer.add, BitVec.toNat_add, (entry_ov ho hj).1, ho,
      show (0 : BitVec 64).toNat = 0 from rfl]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  · rw [MemoryState.readAt_add_of_readAt hf (entry_ov ho hj).2 hw hA, (entry_ov ho hj).1,
      show 168 * j * 8 = j * 1344 by omega, BitVec.extractLsb'_packLanes _ _ hj]

/-- The zero point. -/
def ZPt.zero : ZPt :=
  ⟨fun _ => 0, fun _ => 0, fun _ => 0, fun _ => 0⟩

/-- Its bytes, rest zero, are zero. -/
theorem ZPt.zero_bits : ZPt.zero.bits 0#64 = 0 := by
  simp only [ZPt.zero, ZPt.bits, limbsBits]
  bv_decide

/-- Entry `j` of the table at `c`, lane `j` a point's bits: that point. -/
theorem tbl_entry {Q : ZPt} {r : BitVec 64} {m : MemoryState} {c : Pointer}
    {v : Vector (BitVec 1344) 9} (hf : Fits m c 12096) (ho : c.offset = 0)
    (hA : m.readAt c 12096 = BitVec.packLanes v) (hj : j < 9) (hv : v[j] = Q.bits r) :
    m.PtFit (c.add (BitVec.ofNat 64 (168 * j))) ∧
      m.readPt (c.add (BitVec.ofNat 64 (168 * j))) = Q := by
  obtain ⟨h1, h2⟩ := readAt_tbl hf ho hA hj
  exact ⟨h1, (MemoryState.readPt_of_readAt h1 (h2.trans hv)).1⟩

/-- A temporary at `t` holding `Q`, rest zero. -/
theorem tmp_facts {Q : ZPt} {m : MemoryState} {t : Pointer} (hf : Fits m t 1344) (ho : t.offset = 0)
    (h : m.readAt t 1344 = Q.bits 0#64) : m.PtFit t ∧ m.readRest t = 0#64 :=
  ⟨MemoryState.PtFit.of_fits hf ho,
    (MemoryState.readPt_of_readAt (MemoryState.PtFit.of_fits hf ho) h).2⟩

/-- `dbl`'s `call_eq` into a temporary whose rest is zero. -/
theorem Edwards25519_dbl.call_eq_tmp (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hr : s.mem.readRest out = 0#64) (hp : s.mem.PtFit p)
    (hPd : s.mem.readPt p = P) (hX : Fe.Lt P.x (2 ^ 53)) (hY : Fe.Lt P.y (2 ^ 53))
    (hZ : Fe.Lt P.z (2 ^ 53)) :
    Edwards25519_dbl.call (Edwards25519_dbl.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 28⟩,
            mem := s.mem.storeAt out ((Edwards25519.dbl.spec P).bits 0#64) }) := by
  rw [Edwards25519_dbl.call_eq_of out p s hwf hout hp hPd hX hY hZ, hr]
  rfl

/-- `add`'s `call_eq` into a temporary whose rest is zero. -/
theorem Edwards25519_add.call_eq_tmp (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hr : s.mem.readRest out = 0#64) (hp : s.mem.PtFit p)
    (hq : s.mem.PtFit q) (hPd : s.mem.readPt p = P) (hQd : s.mem.readPt q = Q) (hP : P.Lt (2 ^ 53))
    (hQ : Q.Lt (2 ^ 53)) :
    Edwards25519_add.call (Edwards25519_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 38⟩,
            mem := s.mem.storeAt out ((Edwards25519.add.spec P Q).bits 0#64) }) := by
  subst hPd hQd
  rw [Edwards25519_add.call_eq out p q s hwf hout hp hq hP hQ, hr]
  rfl

/-- `hA`'s table, entry `j` stored over a checkpoint: `hA1` for `tbl_post`, and the entry's fit as
`hcj`. -/
local macro "tbl_pre " j:num : tactic =>
  `(tactic|
    ( checkpoint hck
      have $(Lean.mkIdent `hA1):ident := fun x =>
        readAt_tbl_storeAt $(Lean.mkIdent `hc_fits) $(Lean.mkIdent `hc_off) $(Lean.mkIdent `hA)
          (j := $j) (by omega) x
      have $(Lean.mkIdent `hcj):ident :=
        (readAt_tbl $(Lean.mkIdent `hc_fits) $(Lean.mkIdent `hc_off) $(Lean.mkIdent `hA) (j := $j)
            (by omega)).1.2
      simp only [Nat.reduceMul] at $(Lean.mkIdent `hcj):ident
      clear $(Lean.mkIdent `hA)))

/-- After a table store over a checkpoint: `hA1`'s table fact for `x`, as `hA` on `S`. -/
local macro "tbl_post " x:term : tactic =>
  `(tactic|
    ( have $(Lean.mkIdent `hA):ident := $(Lean.mkIdent `hA1) $x
      simp only [Nat.mul_zero, Nat.mul_one, Nat.reduceMul, BitVec.ofNat_eq_ofNat,
        Pointer.add_zero] at $(Lean.mkIdent `hA):ident
      have hm := congrArg GlobalState.mem $(Lean.mkIdent `hS)
      dsimp only at hm
      rw [← hm] at $(Lean.mkIdent `hA):ident
      clear hm $(Lean.mkIdent `hA1)))

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

/-- `Edwards25519.precompute` stores `bits P r` at `out`, `P` and `r` read at `p`, for limbs below
`2^53`. -/
public theorem Edwards25519_precompute.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 12096) (hp : s.mem.PtFit p) (hP : (s.mem.readPt p).Lt (2 ^ 53)) :
    Edwards25519_precompute.call (Edwards25519_precompute.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 230⟩,
            mem :=
              s.mem.storeAt out
                (Edwards25519.precompute.bits (s.mem.readPt p) (s.mem.readRest p)) }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hP
  generalize hRd : S.mem.readRest p = R
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  have hR₀ : S₀.mem.readRest p = R := hS ▸ hRd
  have hp₀ : S₀.mem.PtFit p := hS ▸ hp
  rw [hP₀, hR₀]
  have hpr : S.mem.readAt p 1344 = P.bits R := by
    rw [← hPd, ← hRd]; exact MemoryState.readAt_eq_ptBits hp.2 hp.1
  clear hPd hRd
  block_init
  step_pure
  step_addressof Edwards25519_identityElement.value_eq with g
  obtain ⟨hgP, hgI, hgR⟩ := MemoryState.readPt_identity hg_fits hg_off hread_g
  have hgr : S.mem.readAt g 1344 = Edwards25519.identity.bits 0#64 := by
    rw [← hgI, ← hgR]; exact MemoryState.readAt_eq_ptBits hgP.2 hgP.1
  clear hread_g hg_fits hgI hgR
  iterate 7 step_pure
  step_alloca with t9
  have hz9 : S.mem.readAt t9 1344 = ZPt.zero.bits 0#64 := by
    rw [hS, ht9, ZPt.zero_bits]; exact readAt_alloca_allocaPtr
  step_alloca with t10
  have hz10 : S.mem.readAt t10 1344 = ZPt.zero.bits 0#64 := by
    rw [hS, ht10, ZPt.zero_bits]; exact readAt_alloca_allocaPtr
  step_alloca with c
  have hA : S.mem.readAt c 12096 = BitVec.packLanes (Vector.replicate 9 (0#1344)) := by
    rw [hS, hc, packLanes_zero]; exact readAt_alloca_allocaPtr
  checkpoint hck0
  have hA1 := fun x => readAt_tbl_storeAt hc_fits hc_off hA (j := 0) (by omega) x
  have hc1344 := hc_fits.mono (show 1344 ≤ 12096 by omega)
  step_memcpy consuming hc1344
  tbl_post (Edwards25519.identity.bits 0#64)
  step_pure
  checkpoint hck1
  have hA1 := fun x => readAt_tbl_storeAt hc_fits hc_off hA (j := 1) (by omega) x
  have hc1 := (readAt_tbl hc_fits hc_off hA (j := 1) (by omega)).1
  have hc1344 := hc1.2
  have hp1344 := hp.2
  step_memcpy consuming hc1344 hp1344
  tbl_post (P.bits R)
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  iterate 3 step_pure
  finish_block
  block_init
  iterate 2 step_pure
  obtain ⟨e1, e2⟩ := tbl_entry (Q := P) (r := R) hc_fits hc_off hA (j := 1) (by omega) (by simp)
  obtain ⟨f1, f2⟩ := tmp_facts ht10_fits ht10_off hz10
  have hPx := hP.1
  have hPy := hP.2.1
  have hPz := hP.2.2.1
  step_call using Edwards25519_dbl.call_eq_tmp consuming f1 f2 e1 e2 hPx hPy hPz
  finish_block
  block_init
  tbl_pre 2
  step_memcpy consuming hcj
  tbl_post ((Edwards25519.dbl.spec P).bits 0#64)
  next_iter 2
  -- 3: entry 2 plus `P`
  step_pure [show (3#64).saddOverflow 18446744073709551615#64 = false by decide]
  step_pure
  have hB : (Edwards25519.dbl.spec P).Lt (2 ^ 53) := (Edwards25519.dbl.spec_lt _).mono53
  obtain ⟨e1, e2⟩ :=
    tbl_entry (Q := Edwards25519.dbl.spec P) (r := 0#64) hc_fits hc_off hA (j := 2) (by omega)
      (by simp)
  obtain ⟨f1, f2⟩ := tmp_facts ht9_fits ht9_off hz9
  have q2 := (MemoryState.readPt_of_readAt hp hpr).1
  step_call using Edwards25519_add.call_eq_tmp consuming f1 f2 e1 e2 q2 hB
  finish_block
  block_init
  tbl_pre 3
  step_memcpy consuming hcj
  tbl_post ((Edwards25519.add.spec (Edwards25519.dbl.spec P) P).bits 0#64)
  next_iter 3
  -- 4: dbl of entry 2
  iterate 2 step_pure
  have hB : (Edwards25519.dbl.spec P).Lt (2 ^ 53) := (Edwards25519.dbl.spec_lt _).mono53
  have hX := hB.1
  have hY := hB.2.1
  have hZ := hB.2.2.1
  obtain ⟨e1, e2⟩ :=
    tbl_entry (Q := Edwards25519.dbl.spec P) (r := 0#64) hc_fits hc_off hA (j := 2) (by omega)
      (by simp)
  obtain ⟨f1, f2⟩ := tmp_facts ht10_fits ht10_off hread_t10
  step_call using Edwards25519_dbl.call_eq_tmp consuming f1 f2 e1 e2 hX hY hZ hB
  finish_block
  block_init
  tbl_pre 4
  step_memcpy consuming hcj
  tbl_post ((Edwards25519.dbl.spec (Edwards25519.dbl.spec P)).bits 0#64)
  next_iter 4
  -- 5: entry 4 plus `P`
  step_pure [show (5#64).saddOverflow 18446744073709551615#64 = false by decide]
  step_pure
  have hB : (Edwards25519.dbl.spec (Edwards25519.dbl.spec P)).Lt (2 ^ 53) :=
    (Edwards25519.dbl.spec_lt _).mono53
  obtain ⟨e1, e2⟩ :=
    tbl_entry (Q := Edwards25519.dbl.spec (Edwards25519.dbl.spec P)) (r := 0#64) hc_fits hc_off hA
      (j := 4) (by omega) (by simp)
  obtain ⟨f1, f2⟩ := tmp_facts ht9_fits ht9_off hread_t9
  have q2 := (MemoryState.readPt_of_readAt hp hpr).1
  step_call using Edwards25519_add.call_eq_tmp consuming f1 f2 e1 e2 q2 hB
  finish_block
  block_init
  tbl_pre 5
  step_memcpy consuming hcj
  tbl_post ((Edwards25519.add.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P)) P).bits 0#64)
  next_iter 5
  -- 6: dbl of entry 3
  iterate 2 step_pure
  have hB : (Edwards25519.add.spec (Edwards25519.dbl.spec P) P).Lt (2 ^ 53) :=
    (Edwards25519.add.spec_lt _ _).mono53
  have hX := hB.1
  have hY := hB.2.1
  have hZ := hB.2.2.1
  obtain ⟨e1, e2⟩ :=
    tbl_entry (Q := Edwards25519.add.spec (Edwards25519.dbl.spec P) P) (r := 0#64) hc_fits hc_off hA
      (j := 3) (by omega) (by simp)
  obtain ⟨f1, f2⟩ := tmp_facts ht10_fits ht10_off hread_t10
  step_call using Edwards25519_dbl.call_eq_tmp consuming f1 f2 e1 e2 hX hY hZ hB
  finish_block
  block_init
  tbl_pre 6
  step_memcpy consuming hcj
  tbl_post ((Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)).bits 0#64)
  next_iter 6
  -- 7: entry 6 plus `P`
  step_pure [show (7#64).saddOverflow 18446744073709551615#64 = false by decide]
  step_pure
  have hB :
    (Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)).Lt (2 ^ 53) :=
    (Edwards25519.dbl.spec_lt _).mono53
  obtain ⟨e1, e2⟩ :=
    tbl_entry (Q := Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)) (r :=
      0#64) hc_fits hc_off hA (j := 6) (by omega) (by simp)
  obtain ⟨f1, f2⟩ := tmp_facts ht9_fits ht9_off hread_t9
  have q2 := (MemoryState.readPt_of_readAt hp hpr).1
  step_call using Edwards25519_add.call_eq_tmp consuming f1 f2 e1 e2 q2 hB
  finish_block
  block_init
  tbl_pre 7
  step_memcpy consuming hcj
  tbl_post
    ((Edwards25519.add.spec
          (Edwards25519.dbl.spec (Edwards25519.add.spec (Edwards25519.dbl.spec P) P)) P).bits
      0#64)
  next_iter 7
  -- 8: dbl of entry 4
  iterate 2 step_pure
  have hB : (Edwards25519.dbl.spec (Edwards25519.dbl.spec P)).Lt (2 ^ 53) :=
    (Edwards25519.dbl.spec_lt _).mono53
  have hX := hB.1
  have hY := hB.2.1
  have hZ := hB.2.2.1
  obtain ⟨e1, e2⟩ :=
    tbl_entry (Q := Edwards25519.dbl.spec (Edwards25519.dbl.spec P)) (r := 0#64) hc_fits hc_off hA
      (j := 4) (by omega) (by simp)
  obtain ⟨f1, f2⟩ := tmp_facts ht10_fits ht10_off hread_t10
  step_call using Edwards25519_dbl.call_eq_tmp consuming f1 f2 e1 e2 hX hY hZ hB
  finish_block
  block_init
  tbl_pre 8
  step_memcpy consuming hcj
  tbl_post ((Edwards25519.dbl.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P))).bits 0#64)
  step_pure [show (8#64).saddOverflow 1#64 = false by decide,
    show (8#64).uaddOverflow 1#64 = false by decide]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  have ho := hout
  step_memcpy consuming ho hc_fits
  finish_block
  rw [hS]
  clear hS hwf
  subst_vars
  erase_frame
  simp only [GlobalState.alloca, Edwards25519.precompute.bits]
  congr 4

/-- Entry `i` of the table stored at `out`: its point, `P`'s last 8 bytes at `1`, zero elsewhere. -/
public theorem _root_.MLIR.MemoryState.readPt_precompute {m : MemoryState} {out : Pointer}
    (P : ZPt) (r : BitVec 64) (i : Fin 9) (hf : Fits m out 12096)
    (ho : out.offset.toNat + 1512 ≤ 2 ^ 64) :
    (m.storeAt out (Edwards25519.precompute.bits P r)).PtFit
        (out.add (BitVec.ofNat 64 (168 * i.val))) ∧
      (m.storeAt out (Edwards25519.precompute.bits P r)).readPt
          (out.add (BitVec.ofNat 64 (168 * i.val))) =
        (Edwards25519.precompute.spec P)[i] ∧
      (m.storeAt out (Edwards25519.precompute.bits P r)).readRest
          (out.add (BitVec.ofNat 64 (168 * i.val))) =
        if i.val = 1 then r else 0#64 := by
  have hi := i.isLt
  have hn : (BitVec.ofNat 64 (168 * i.val)).toNat = 168 * i.val := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have hov : ¬out.offset.uaddOverflow (BitVec.ofNat 64 (168 * i.val)) := by
    simp only [BitVec.uaddOverflow, hn, decide_eq_true_eq, Nat.not_le]; omega
  have hwd : (BitVec.ofNat 64 (168 * i.val)).toNat * 8 + 1344 ≤ 12096 := by
    rw [hn]; omega
  have hq :
    (m.storeAt out (Edwards25519.precompute.bits P r)).PtFit
      (out.add (BitVec.ofNat 64 (168 * i.val))) := by
    refine ⟨?_, Fits.add_of_le hov hwd hf.storeAt⟩
    simp only [Pointer.add, BitVec.toNat_add, hn]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  have h := MemoryState.readAt_storeAt_add (w := 1344) hf hov hwd (Edwards25519.precompute.bits P r)
  rw [hn, show 168 * i.val * 8 = i.val * 1344 by omega, Edwards25519.precompute.bits,
    BitVec.extractLsb'_packLanes _ _ hi, Vector.getElem_ofFn] at h
  exact ⟨hq, MemoryState.readPt_of_readAt hq h⟩

end Proof

end MLIR.Zig
