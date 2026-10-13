module

public import Agave.Common.Tactics
public import Agave.Avx2.Mlir.impl_mul
public import Agave.Avx2.impl_mul.Spec
public import Agave.Avx2.NafLookupTable5_CachedPoint_select
public import Agave.Serial.mul.Loop
public import Firedancer.Common.Tactics
public meta import Lean.Elab.Tactic
public import MLIR.Run.Tactic
public meta import MLIR.Run.Tactic.Util
import all Agave.Serial.mul.Loop
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.IntervalCases
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `vartime_double_base::spec_avx2::mul`'s loops, block by block: the start index search, the
loop `Q = Q.double() ± A_i ± B_j` from it down to `0`, and the final `Q.into()`. -/

namespace MLIR.Agave.Avx2.impl_mul

open Serial.mul (digit start DigitsA DigitsB eq_zero_of_ofNat64 saddOverflow_neg_one64 add_neg_one64
  add_neg_one64_succ mod64 or_one digit_zero start_succ_zero start_succ_ne sign_cases lo128
  not_pos_of_neg not_neg_of_pos ne_zero_of_pos)
open NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from
open
  NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from renaming
  spec → tableSpec

/-! ### Slots, registers and facts -/

/-- The function's slots in `alloca` order: the identity's global block, the digits' `select`
outputs and sums (`b_naf` negative, positive, `a_naf` negative, positive), `Q.double()`, `Q`,
`table_A` and the NAFs. -/
public structure Slots where
  idp : Pointer
  selBm : Pointer
  sumBm : Pointer
  selBp : Pointer
  sumBp : Pointer
  selAm : Pointer
  sumAm : Pointer
  selAp : Pointer
  sumAp : Pointer
  dbl : Pointer
  Q : Pointer
  table_A : Pointer
  b_naf : Pointer
  a_naf : Pointer

/-- `σ`'s slots are `B`'s, from its counter on. -/
public structure Slots.At (σ : Slots) (B : GlobalState) : Prop where
  idp : σ.idp = B.slot 0
  selBm : σ.selBm = B.slot 1
  sumBm : σ.sumBm = B.slot 2
  selBp : σ.selBp = B.slot 3
  sumBp : σ.sumBp = B.slot 4
  selAm : σ.selAm = B.slot 5
  sumAm : σ.sumAm = B.slot 6
  selAp : σ.selAp = B.slot 7
  sumAp : σ.sumAp = B.slot 8
  dbl : σ.dbl = B.slot 9
  Q : σ.Q = B.slot 10
  table_A : σ.table_A = B.slot 11
  b_naf : σ.b_naf = B.slot 12
  a_naf : σ.a_naf = B.slot 13

/-- The registers the function's loops read: constants and the slots. -/
public abbrev BaseRegs (σ : Slots) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%137 := 18446744073709551615#64, %138 := 0#8, %139 := 0#64, %140 := σ.idp, %141 := 160#64,
    %142 := 26#64, %143 := Vector.replicate 8 PoisonOr.poison, %144 := 1#64, %145 :=
    Vector.replicate 2 26#64, %146 := σ.selBm, %147 := σ.sumBm, %148 := σ.selBp, %149 := σ.sumBp,
    %150 := σ.selAm, %151 := σ.sumAm, %152 := σ.selAp, %153 := σ.sumAp, %154 := σ.dbl, %155 := σ.Q,
    %156 := σ.table_A, %157 := σ.b_naf, %158 := σ.a_naf]

/-! ### Counters -/

/-- `i - 1` on a small counter does not overflow. -/
theorem saddOverflow_neg_one64' {i : Nat} (h : i ≤ 256) :
    (BitVec.ofNat 64 i).saddOverflow 18446744073709551615#64 = false := by
  have hn : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (18446744073709551615#64).toInt = -1 := by decide
  simp [BitVec.saddOverflow, hn, hm]
  omega

/-! ### The start search -/

/-- `for j in (0..256).rev() { i = j; if a_naf[i] != 0 || b_naf[i] != 0 { break; } }` from `^bb2`
at `i + 1`: on to `^bb1` with `start` of it. -/
public theorem search_loop (out a A b : Pointer) (σ : Slots) (an bn : BitVec (8 * 256))
    (S : GlobalState) (haF : Fits S.mem σ.a_naf 2048) (haR : S.mem.readAt σ.a_naf 2048 = an)
    (hbF : Fits S.mem σ.b_naf 2048) (hbR : S.mem.readAt σ.b_naf 2048 = bn)
    (ha_off : σ.a_naf.offset = 0) (hb_off : σ.b_naf.offset = 0)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (_ : i < 256) (E : ⟪Γ⟫),
      E.args = (args (.value out) (.value a) (.value A) (.value b)).get →
        BaseRegs σ E →
        (E ⊨ [%160 := BitVec.ofNat 64 (i + 1)]) →
        (∀ E' : ⟪Γ⟫,
          E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
            BaseRegs σ E' →
            (E' ⊨ [%159 := BitVec.ofNat 64 (start an bn i)]) →
            (impl_mul.runFrom E' ^bb1 S >>= g) = K) →
        (impl_mul.runFrom E ^bb2 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi E hArgs hR hRi hK
    block_init
    step_pure [saddOverflow_neg_one64 (i := 1) (by omega) (by omega),
      add_neg_one64_succ (i := 0) (by omega)]
    step_pure
    step_load [← digit_zero] with da
    step_pure
    finish_block
    case isFalse =>
      subst hS
      exact hK E hArgs (by env_reads) (by env_reads)
    block_init
    step_pure
    step_load [← digit_zero] with db
    iterate 3 step_pure
    finish_block
    case isFalse => exact absurd (or_one _) hbr
    subst hS
    exact hK E hArgs (by env_reads) (by env_reads)
  | succ j ih =>
    intro hi E hArgs hR hRi hK
    block_init
    step_pure [saddOverflow_neg_one64 (i := j + 1 + 1) (by omega) (by omega),
      add_neg_one64_succ (i := j + 1) (by omega)]
    step_pure [mod64 hi]
    step_load [mod64 hi] with da
    step_pure
    finish_block
    case
      isFalse =>
      have hne : ¬(digit an (j + 1) = 0#8 ∧ digit bn (j + 1) = 0#8) := fun h =>
        hbr (by simp [hda, h.1])
      subst hS
      refine hK E hArgs (by env_reads) ?_
      rw [start_succ_ne hne]
      env_reads
    have ha0 : digit an (j + 1) = 0#8 := by simpa [hda] using hbr
    block_init
    step_pure [mod64 hi]
    step_load [mod64 hi] with db
    iterate 3 step_pure
    finish_block
    case
      isTrue =>
      have hne : ¬(digit an (j + 1) = 0#8 ∧ digit bn (j + 1) = 0#8) := fun h => by
        simp [hdb, h.2] at hbr
        exact absurd (eq_zero_of_ofNat64 hi hbr) (by omega)
      subst hS
      refine hK E hArgs (by env_reads) ?_
      rw [start_succ_ne hne]
      env_reads
    have hb0 : digit bn (j + 1) = 0#8 := by
      simp [hdb] at hbr
      exact hbr.1
    subst hS
    refine ih (by omega) E hArgs (by env_reads) (by env_reads) fun E' h₁ h₂ h₃ => ?_
    refine hK E' h₁ h₂ ?_
    rw [start_succ_zero ⟨ha0, hb0⟩]
    exact h₃

/-! ### The loop's facts -/

/-- The loop's temporaries from `B`'s counter on are in bounds: slots `1 … 9`. -/
@[expose]
public def SlotsIn (m : MemoryState) (B : GlobalState) : Prop :=
  ∀ k, 1 ≤ k → k ≤ 9 → InBounds m (B.slot k) 1280

section Slots

variable {m : MemoryState} {B : GlobalState}

/-- A temporary's slot. -/
public theorem SlotsIn.at (h : SlotsIn m B) (k : Nat) (h1 : 1 ≤ k := by decide)
    (h9 : k ≤ 9 := by decide) : InBounds m (B.slot k) 1280 :=
  h k h1 h9

@[mlir_transport]
public theorem SlotsIn.lifetimeStart (h : SlotsIn m B) : SlotsIn (m.lifetimeStart q) B :=
  fun k h1 h2 => (h k h1 h2).lifetimeStart

@[mlir_transport]
public theorem SlotsIn.lifetimeEnd (h : SlotsIn m B) : SlotsIn (m.lifetimeEnd q) B := fun k h1 h2 =>
  (h k h1 h2).lifetimeEnd

@[mlir_transport]
public theorem SlotsIn.storeFe4x (h : SlotsIn m B) : SlotsIn (m.storeFe4x q v) B := fun k h1 h2 =>
  (h k h1 h2).storeFe4x

@[mlir_transport]
public theorem SlotsIn.storeAt {x : BitVec w} (h : SlotsIn m B) : SlotsIn (m.storeAt q x) B :=
  fun k h1 h2 => (h k h1 h2).storeAt

end Slots

/-- What the loop needs of a state: room at `out`, `Q` known, the temporaries in bounds, the
NAFs' bytes and `table_A` in place. -/
public structure LoopFacts (S : GlobalState) (σ : Slots) (B : GlobalState) (out : Pointer)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) : Prop where
  wf : S.WF
  outRoom : Room S.mem out 1280
  outOff : out.offset.toNat + 160 ≤ 2 ^ 64
  slots : SlotsIn S.mem B
  QF : Fits S.mem σ.Q 1280
  aF : Fits S.mem σ.a_naf 2048
  aR : S.mem.readAt σ.a_naf 2048 = an
  bF : Fits S.mem σ.b_naf 2048
  bR : S.mem.readAt σ.b_naf 2048 = bn
  outLt : out.id.id < B.alloc.nextFreeBlock
  tAF : Fits S.mem σ.table_A 10240
  tAR : S.mem.readAt σ.table_A 10240 = naf5Bits (tableSpec P)

open Lean Elab Tactic Meta in
/-- `tag_slots h₁ …`: the equations `x = B.slot k`, tagged as a step's named values, so the steps
keep the slots folded, as they keep an `alloca`'s. -/
local elab "tag_slots " hs:ident* : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for h in hs do
      let d ← getLocalDeclFromUserName h.getId
      g ← g.replaceLocalDeclDefEq d.fvarId (Tactic.tagNamed d.type)
    replaceMainGoal [g]

set_option hygiene false in
/-- The slots' equations, tagged as `alloca`'s are. -/
local macro "open_slots " hσ:ident : tactic =>
  `(tactic|
    ( obtain
        ⟨hidp, hselBm, hsumBm, hselBp, hsumBp, hselAm, hsumAm, hselAp, hsumAp, hdbl, hQ, htable_A,
          hb_naf, ha_naf⟩ :=
        $hσ
      dsimp only at *
      tag_slots hidp hselBm hsumBm hselBp hsumBp hselAm hsumAm hselAp hsumAp hdbl hQ htable_A hb_naf
        ha_naf))

/-! ### Calls on known bits -/

/-- The registers at `p`, of known bits: they fit, and they are `v`. -/
theorem fe4x_of_bits {m : MemoryState} {p : Pointer} {v : Fe2625x4} (hf : Fits m p 1280)
    (ho : p.offset = 0) (hr : m.readAt p 1280 = fe4xBits v) : m.Fe4xFit p ∧ m.readFe4x p = v :=
  ⟨MemoryState.Fe4xFit.of_fits hf (by simp [ho]),
    MemoryState.readFe4x_of_readAt hf.inBounds (by simp [ho]) hr⟩

/-- A table's entries, of known bits. -/
theorem readNaf5_of_readAt {m : MemoryState} {p : Pointer} {T : Fin 8 → Fe2625x4}
    (hf : Fits m p 10240) (ho : p.offset = 0) (hr : m.readAt p 10240 = naf5Bits T) :
    m.readNaf5 p = T := by
  funext j
  have := j.isLt
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (160 * j)) := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat, ho]
    rw [Nat.mod_eq_of_lt (by omega)]; simp; omega
  have hk : (BitVec.ofNat 64 (160 * j)).toNat = 160 * j := by
    simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]
  refine
    MemoryState.readFe4x_of_readAt (Fits.add_of_le hov (by omega) hf).inBounds
      (by
        rw [Naf5.entry_offset (by simp [ho])]; simp [ho]; omega)
      ?_
  rw [MemoryState.readAt_add_of_readAt hf.inBounds hov (by omega) hr, hk]
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7⟩ :=
    extract_append8 (fe4xBits (T 0)) (fe4xBits (T 1)) (fe4xBits (T 2)) (fe4xBits (T 3))
      (fe4xBits (T 4)) (fe4xBits (T 5)) (fe4xBits (T 6)) (fe4xBits (T 7))
  fin_cases j
  exacts [e0, e1, e2, e3, e4, e5, e6, e7]

/-- `self.double()` on registers of known bits. -/
theorem double_call_eq (out x : Pointer) (s : GlobalState) (hwf : s.WF) (hout : s.mem.Fe4xRoom out)
    (hx : Fits s.mem x 1280) (hxo : x.offset = 0) {v : Fe2625x4}
    (hv : s.mem.readAt x 1280 = fe4xBits v) :
    ExtendedPoint_double_impl_double.call
        (ExtendedPoint_double_impl_double.args (.value out) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem := s.mem.storeFe4x out (ExtendedPoint_double_impl_double.spec v) }) := by
  obtain ⟨hf, hr⟩ := fe4x_of_bits hx hxo hv
  rw [ExtendedPoint_double_impl_double.call_eq out x s hwf hout hf, hr]

/-- `&self + &other` on `self` of known bits. -/
theorem add_call_eq (out p q : Pointer) (s : GlobalState) (hwf : s.WF) (hout : s.mem.Fe4xRoom out)
    (hp : Fits s.mem p 1280) (hpo : p.offset = 0) {v c : Fe2625x4}
    (hv : s.mem.readAt p 1280 = fe4xBits v) (hq : s.mem.Fe4xFit q) (hc : s.mem.readFe4x q = c) :
    ExtendedPoint_Add_CachedPoint_add_impl_add.call
        (ExtendedPoint_Add_CachedPoint_add_impl_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem :=
              s.mem.storeFe4x out (ExtendedPoint_Add_CachedPoint_add_impl_add.spec v c) }) := by
  obtain ⟨hf, hr⟩ := fe4x_of_bits hp hpo hv
  rw [ExtendedPoint_Add_CachedPoint_add_impl_add.call_eq out p q s hwf hout hf hq, hr, hc]

/-- `&self - &other` on `self` of known bits. -/
theorem sub_call_eq (out p q : Pointer) (s : GlobalState) (hwf : s.WF) (hout : s.mem.Fe4xRoom out)
    (hp : Fits s.mem p 1280) (hpo : p.offset = 0) {v c : Fe2625x4}
    (hv : s.mem.readAt p 1280 = fe4xBits v) (hq : s.mem.Fe4xFit q) (hc : s.mem.readFe4x q = c) :
    ExtendedPoint_Sub_CachedPoint_sub_impl_sub.call
        (ExtendedPoint_Sub_CachedPoint_sub_impl_sub.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem :=
              s.mem.storeFe4x out (ExtendedPoint_Sub_CachedPoint_sub_impl_sub.spec v c) }) := by
  obtain ⟨hf, hr⟩ := fe4x_of_bits hp hpo hv
  rw [ExtendedPoint_Sub_CachedPoint_sub_impl_sub.call_eq out p q s hwf hout hf hq, hr, hc]

/-- `table_A.select(x)`, `x / 2 = k`, on a table of known bits: `tableA P k`. -/
theorem selA_call_eq (out tbl : Pointer) (x : BitVec 64) (s : GlobalState) (hwf : s.WF)
    {P : EdwardsPoint} {k : Nat} (hk : x.toNat / 2 = k) (hx : x.toNat < 16)
    (hout : Room s.mem out 1280) (hoo : out.offset = 0) (hf : Fits s.mem tbl 10240)
    (hto : tbl.offset = 0) (hr : s.mem.readAt tbl 10240 = naf5Bits (tableSpec P))
    (hsep : out.id ≠ tbl.id) :
    NafLookupTable5_CachedPoint_select.call
        (NafLookupTable5_CachedPoint_select.args (.value out) (.value tbl) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem.storeFe4x out (tableA P k) }) := by
  rw [NafLookupTable5_CachedPoint_select.call_eq out tbl x s hwf hx hout (by simp [hoo])
      ⟨by simp [hto], hf⟩ hsep,
    readNaf5_of_readAt hf hto hr]
  subst hk
  rfl

/-- `table_B.select(x)`, `x / 2 = k`: `BASEPOINT_ODD_LOOKUP_TABLE`'s entry `k`. -/
theorem selB_call_eq (out : Pointer) (x : BitVec 64) (s : GlobalState) (hwf : s.WF) {k : Nat}
    (hk : x.toNat / 2 = k) (hx : x.toNat < 128) (hout : Room s.mem out 1280)
    (hoo : out.offset = 0) :
    NafLookupTable8_CachedPoint_select.call
        (NafLookupTable8_CachedPoint_select.args (.value out) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeFe4x out (BASEPOINT_ODD_LOOKUP_TABLE.point k) }) := by
  rw [NafLookupTable8_CachedPoint_select.call_eq out x s hwf hx hout (by simp [hoo]), hk]

/-! ### Digits and indices -/

/-- A positive digit, sign-extended. -/
theorem sext_pos {d : BitVec 8} (hpos : (0#8).slt d = true) :
    BitVec.signExtend 64 d = d.setWidth 64 := by bv_decide

/-- A negative digit above `-128`, negated and sign-extended. -/
theorem sext_neg {d : BitVec 8} (hneg : d.slt 0#8 = true) (hlo : (128#8).slt d = true) :
    BitVec.signExtend 64 (-d) = (-d).setWidth 64 := by bv_decide

theorem toNat_setWidth8 (d : BitVec 8) : (d.setWidth 64).toNat = d.toNat := by
  rw [BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by omega)

/-- A positive digit's index, `d / 2`, as the code computes it. -/
theorem pos_idx {d : BitVec 8} (hpos : (0#8).slt d = true) :
    (BitVec.signExtend 64 d).toNat / 2 = (d >>> 1).toNat := by
  rw [sext_pos hpos, toNat_setWidth8, BitVec.toNat_ushiftRight, Nat.shiftRight_one]

/-- A negative digit's index, `-d / 2`, as the code computes it. -/
theorem neg_idx {d : BitVec 8} (hneg : d.slt 0#8 = true) (hlo : (128#8).slt d = true) :
    (BitVec.signExtend 64 (-d)).toNat / 2 = ((-d) >>> 1).toNat := by
  rw [sext_neg hneg hlo, toNat_setWidth8, BitVec.toNat_ushiftRight, Nat.shiftRight_one]

/-- A positive digit below `c`, sign-extended: below `c`. -/
theorem pos_lt {d : BitVec 8} {c : Nat} (hpos : (0#8).slt d = true) (hhi : d.toInt < c) :
    (BitVec.signExtend 64 d).toNat < c := by
  have h0 : 0 < d.toInt := by
    simpa only [BitVec.slt, decide_eq_true_eq, BitVec.toInt_zero] using hpos
  rw [sext_pos hpos, toNat_setWidth8]
  have hc := BitVec.toInt_eq_toNat_cond d
  have := d.isLt
  split at hc <;> omega

/-- A negative digit above `-c`, `c ≤ 128`, negated and sign-extended: below `c`. -/
theorem neg_lt {d : BitVec 8} {c : Nat} (hneg : d.slt 0#8 = true) (hlo : -(c : Int) < d.toInt)
    (hc : c ≤ 128) : (BitVec.signExtend 64 (-d)).toNat < c := by
  have h0 : d.toInt < 0 := by
    simpa only [BitVec.slt, decide_eq_true_eq, BitVec.toInt_zero] using hneg
  have hlo' : (128#8).slt d = true := by
    rw [BitVec.slt_iff_toInt_lt]
    have : (128#8).toInt = -128 := by decide
    omega
  rw [sext_neg hneg hlo', toNat_setWidth8, BitVec.toNat_neg]
  have h := BitVec.toInt_eq_toNat_cond d
  have := d.isLt
  split at h <;> omega

/-! ### The loop's blocks -/

set_option hygiene false in
/-- Closes the targets of a `switch` on a known `scmp` that it does not take. -/
local macro "switch_drop" : tactic =>
  `(tactic|
    all_goals
      try
        first
        | exact absurd hbr (by decide)
        | exact absurd (by decide) hbr
        | exact absurd (by decide) hbr0
        | exact absurd (by decide) hbr1
        | exact absurd (by decide) hbr2)

/-- `^bb4`, an iteration's start at `i`: `Q = Q.double()`, then `a_naf[i]`'s add; on to `^bb8`. -/
theorem headA_block (out a A b : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (hdA : -16 < (digit an i).toInt ∧ (digit an i).toInt < 16) (v : Fe2625x4) (S : GlobalState)
    (E : ⟪Γ⟫) (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get)
    (hR : BaseRegs σ E) (hRi : E ⊨ [%170 := BitVec.ofNat 64 i]) (hF : LoopFacts S σ B out P an bn)
    (hv : S.mem.readAt σ.Q 1280 = fe4xBits v)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
          BaseRegs σ E' →
          (E' ⊨ [%170 := BitVec.ofNat 64 i]) →
          LoopFacts S' σ B out P an bn →
          S'.mem.readAt σ.Q 1280 =
            fe4xBits (addDigit (tableA P) (digit an i) (ExtendedPoint_double_impl_double.spec v)) →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 4 + digitBlocks 1 (digit an i) →
          S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
          (impl_mul.runFrom E' ^bb8 S' >>= g) = K) :
    (impl_mul.runFrom E ^bb4 S >>= g) = K := by
  rcases σ with
    ⟨idp, selBm, sumBm, selBp, sumBp, selAm, sumAm, selAp, sumAp, dbl, Q, table_A, b_naf, a_naf⟩
  obtain ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ := hF
  open_slots hσ
  have hdbl_b : InBounds S.mem dbl 1280 := hdbl ▸ hsl.at 9
  have hdbl_off : dbl.offset = 0 := by
    rw [hdbl]; rfl
  have hQ_off : Q.offset = 0 := by
    rw [hQ]; rfl
  have ha_naf_off : a_naf.offset = 0 := by
    rw [ha_naf]; rfl
  -- Q = Q.double();
  block_init
  step_pure
  have hdbl_fe4 := MemoryState.Fe4xRoom.of_room hroom_dbl (by simp [hdbl_off])
  step_call using double_call_eq
  have hdbl_f := hdbl_fe4.fits
  clear hdbl_fe4 hread_dbl_readFe4x hread_dbl_readAt hread_dbl_32 hread_dbl_64 hread_dbl_96
    hread_dbl_128
  step_memcpy consuming hdbl_f hread_dbl hv
  step_pure
  -- match a_naf[i].cmp(&0)
  step_pure
  step_load [mod64 hi] with d
  have hdd : d = digit an i := hd
  rcases sign_cases (digit an i) with hneg | hz | hpos
  · -- Ordering::Less => Q = &Q - &table_A.select(-a_naf[i] as usize)
    step_pure [hdd, hneg]
    finish_block
    switch_drop
    have hsumAm_b : InBounds S.mem sumAm 1280 := hsumAm ▸ hsl.at 6
    have hselAm_b : InBounds S.mem selAm 1280 := hselAm ▸ hsl.at 5
    have hsumAm_off : sumAm.offset = 0 := by
      rw [hsumAm]; rfl
    have hselAm_off : selAm.offset = 0 := by
      rw [hselAm]; rfl
    have htable_A_off : table_A.offset = 0 := by
      rw [htable_A]; rfl
    block_init
    step_pure
    step_pure
    step_pure with nd
    step_pure with snd
    have hk : snd.toNat / 2 = ((-digit an i) >>> 1).toNat := by
      rw [hsnd, hnd]; exact neg_idx hneg (lo128 (by omega))
    have hk16 : snd.toNat < 16 := by
      rw [hsnd, hnd]; exact neg_lt (c := 16) hneg (by simpa using hdA.1) (by omega)
    have hselAm_fe4 := MemoryState.Fe4xRoom.of_room hroom_selAm (by simp [hselAm_off])
    step_call using (selA_call_eq (hk := hk) (hx := hk16)) consuming hk hk16
    have hsumAm_fe4 := MemoryState.Fe4xRoom.of_room hroom_sumAm (by simp [hsumAm_off])
    step_call using sub_call_eq consuming hselAm_fe4 hread_selAm_readFe4x
    have hsumAm_f := hsumAm_fe4.fits
    clear hsumAm_fe4 hread_sumAm_readFe4x hread_sumAm_readAt hread_sumAm_32 hread_sumAm_64
      hread_sumAm_96 hread_sumAm_128 hread_selAm_readAt hread_selAm_32 hread_selAm_64 hread_selAm_96
      hread_selAm_128 hread_selAm
    step_memcpy consuming hsumAm_f hread_sumAm
    iterate 2 step_pure
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ ?_ ?_ ?_
    · rw [hread_Q]
      simp only [addDigit, not_pos_of_neg hneg, hneg, Bool.false_eq_true, ↓reduceIte]
    · rw [hS]
      simp [digitBlocks, not_pos_of_neg hneg, hneg]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
        MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeFe4x_of_le,
        MemoryState.eraseFrom_storeAt_of_le]
  · -- Ordering::Equal => {}
    step_pure [hdd, hz]
    finish_block
    switch_drop
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ ?_
        (by
          rw [hS]; simp [digitBlocks, hz])
        (by
          rw [hS];
          simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
            MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeFe4x_of_le,
            MemoryState.eraseFrom_storeAt_of_le])
    rw [hread_Q]
    simp only [addDigit, hz]
    rfl
  · -- Ordering::Greater => Q = &Q + &table_A.select(a_naf[i] as usize)
    step_pure [hdd, hpos, ne_zero_of_pos hpos, not_neg_of_pos hpos]
    finish_block
    switch_drop
    have hsumAp_b : InBounds S.mem sumAp 1280 := hsumAp ▸ hsl.at 8
    have hselAp_b : InBounds S.mem selAp 1280 := hselAp ▸ hsl.at 7
    have hsumAp_off : sumAp.offset = 0 := by
      rw [hsumAp]; rfl
    have hselAp_off : selAp.offset = 0 := by
      rw [hselAp]; rfl
    have htable_A_off : table_A.offset = 0 := by
      rw [htable_A]; rfl
    block_init
    step_pure
    step_pure
    step_pure with sd
    have hk : sd.toNat / 2 = (digit an i >>> 1).toNat := by
      rw [hsd, ← hdd]; rw [← hdd] at hpos; exact pos_idx hpos
    have hk16 : sd.toNat < 16 := by
      rw [hsd, ← hdd]; rw [← hdd] at hpos hdA; exact pos_lt (c := 16) hpos hdA.2
    have hselAp_fe4 := MemoryState.Fe4xRoom.of_room hroom_selAp (by simp [hselAp_off])
    step_call using (selA_call_eq (hk := hk) (hx := hk16)) consuming hk hk16
    have hsumAp_fe4 := MemoryState.Fe4xRoom.of_room hroom_sumAp (by simp [hsumAp_off])
    step_call using add_call_eq consuming hselAp_fe4 hread_selAp_readFe4x
    have hsumAp_f := hsumAp_fe4.fits
    clear hsumAp_fe4 hread_sumAp_readFe4x hread_sumAp_readAt hread_sumAp_32 hread_sumAp_64
      hread_sumAp_96 hread_sumAp_128 hread_selAp_readAt hread_selAp_32 hread_selAp_64 hread_selAp_96
      hread_selAp_128 hread_selAp
    step_memcpy consuming hsumAp_f hread_sumAp
    iterate 2 step_pure
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ ?_ ?_ ?_
    · rw [hread_Q]
      simp only [addDigit, hpos, ↓reduceIte]
    · rw [hS]
      simp [digitBlocks, hpos]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
        MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeFe4x_of_le,
        MemoryState.eraseFrom_storeAt_of_le]

/-- `^bb8`: `b_naf[i]`'s add on `Q`; on to `^bb10`. -/
theorem headB_block (out a A b : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (hdB : -128 < (digit bn i).toInt) (v : Fe2625x4)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get) (hR : BaseRegs σ E)
    (hRi : E ⊨ [%170 := BitVec.ofNat 64 i]) (hF : LoopFacts S σ B out P an bn)
    (hv : S.mem.readAt σ.Q 1280 = fe4xBits v)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
          BaseRegs σ E' →
          (E' ⊨ [%170 := BitVec.ofNat 64 i]) →
          LoopFacts S' σ B out P an bn →
          S'.mem.readAt σ.Q 1280 =
            fe4xBits (addDigit BASEPOINT_ODD_LOOKUP_TABLE.point (digit bn i) v) →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + digitBlocks 2 (digit bn i) →
          S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
          (impl_mul.runFrom E' ^bb10 S' >>= g) = K) :
    (impl_mul.runFrom E ^bb8 S >>= g) = K := by
  rcases σ with
    ⟨idp, selBm, sumBm, selBp, sumBp, selAm, sumAm, selAp, sumAp, dbl, Q, table_A, b_naf, a_naf⟩
  obtain ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ := hF
  open_slots hσ
  have hQ_off : Q.offset = 0 := by
    rw [hQ]; rfl
  have hb_naf_off : b_naf.offset = 0 := by
    rw [hb_naf]; rfl
  -- match b_naf[i].cmp(&0)
  block_init
  step_pure
  step_load [mod64 hi] with d
  have hdd : d = digit bn i := hd
  rcases sign_cases (digit bn i) with hneg | hz | hpos
  · -- Ordering::Less => Q = &Q - &table_B.select(-b_naf[i] as usize)
    step_pure [hdd, hneg]
    finish_block
    switch_drop
    have hsumBm_b : InBounds S.mem sumBm 1280 := hsumBm ▸ hsl.at 2
    have hselBm_b : InBounds S.mem selBm 1280 := hselBm ▸ hsl.at 1
    have hsumBm_off : sumBm.offset = 0 := by
      rw [hsumBm]; rfl
    have hselBm_off : selBm.offset = 0 := by
      rw [hselBm]; rfl
    block_init
    step_pure
    step_pure
    step_pure with nd
    step_pure with snd
    have hk : snd.toNat / 2 = ((-digit bn i) >>> 1).toNat := by
      rw [hsnd, hnd]; exact neg_idx hneg (lo128 hdB)
    have hk128 : snd.toNat < 128 := by
      rw [hsnd, hnd]; exact neg_lt (c := 128) hneg (by simpa using hdB) (by omega)
    have hselBm_fe4 := MemoryState.Fe4xRoom.of_room hroom_selBm (by simp [hselBm_off])
    step_call using (selB_call_eq (hk := hk) (hx := hk128)) consuming hk hk128
    have hsumBm_fe4 := MemoryState.Fe4xRoom.of_room hroom_sumBm (by simp [hsumBm_off])
    step_call using sub_call_eq consuming hselBm_fe4 hread_selBm_readFe4x
    have hsumBm_f := hsumBm_fe4.fits
    clear hsumBm_fe4 hread_sumBm_readFe4x hread_sumBm_readAt hread_sumBm_32 hread_sumBm_64
      hread_sumBm_96 hread_sumBm_128 hread_selBm_readAt hread_selBm_32 hread_selBm_64 hread_selBm_96
      hread_selBm_128 hread_selBm
    step_memcpy consuming hsumBm_f hread_sumBm
    iterate 2 step_pure
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ ?_ ?_ ?_
    · rw [hread_Q]
      simp only [addDigit, not_pos_of_neg hneg, hneg, Bool.false_eq_true, ↓reduceIte]
    · rw [hS]
      simp [digitBlocks, not_pos_of_neg hneg, hneg]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
        MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeFe4x_of_le,
        MemoryState.eraseFrom_storeAt_of_le]
  · -- Ordering::Equal => {}
    step_pure [hdd, hz]
    finish_block
    switch_drop
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ ?_
        (by
          rw [hS]; simp [digitBlocks, hz])
        (by rw [hS])
    rw [hv]
    simp only [addDigit, hz]
    rfl
  · -- Ordering::Greater => Q = &Q + &table_B.select(b_naf[i] as usize)
    step_pure [hdd, hpos, ne_zero_of_pos hpos, not_neg_of_pos hpos]
    finish_block
    switch_drop
    have hsumBp_b : InBounds S.mem sumBp 1280 := hsumBp ▸ hsl.at 4
    have hselBp_b : InBounds S.mem selBp 1280 := hselBp ▸ hsl.at 3
    have hsumBp_off : sumBp.offset = 0 := by
      rw [hsumBp]; rfl
    have hselBp_off : selBp.offset = 0 := by
      rw [hselBp]; rfl
    block_init
    step_pure
    step_pure
    step_pure with sd
    have hk : sd.toNat / 2 = (digit bn i >>> 1).toNat := by
      rw [hsd, ← hdd]; rw [← hdd] at hpos; exact pos_idx hpos
    have hk128 : sd.toNat < 128 := by
      rw [hsd, ← hdd]; rw [← hdd] at hpos
      exact
        pos_lt (c := 128) hpos
          (by
            have := BitVec.toInt_lt (x := d); simpa using this)
    have hselBp_fe4 := MemoryState.Fe4xRoom.of_room hroom_selBp (by simp [hselBp_off])
    step_call using (selB_call_eq (hk := hk) (hx := hk128)) consuming hk hk128
    have hsumBp_fe4 := MemoryState.Fe4xRoom.of_room hroom_sumBp (by simp [hsumBp_off])
    step_call using add_call_eq consuming hselBp_fe4 hread_selBp_readFe4x
    have hsumBp_f := hsumBp_fe4.fits
    clear hsumBp_fe4 hread_sumBp_readFe4x hread_sumBp_readAt hread_sumBp_32 hread_sumBp_64
      hread_sumBp_96 hread_sumBp_128 hread_selBp_readAt hread_selBp_32 hread_selBp_64 hread_selBp_96
      hread_selBp_128 hread_selBp
    step_memcpy consuming hsumBp_f hread_sumBp
    iterate 2 step_pure
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ ?_ ?_ ?_
    · rw [hread_Q]
      simp only [addDigit, hpos, ↓reduceIte]
    · rw [hS]
      simp [digitBlocks, hpos]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
        MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeFe4x_of_le,
        MemoryState.eraseFrom_storeAt_of_le]

/-- `^bb10`: out to `^bb12` at `i = 0`, else around at `i - 1`. -/
theorem tail_block (out a A b : Pointer) (σ : Slots) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get) (hR : BaseRegs σ E)
    (hRi : E ⊨ [%170 := BitVec.ofNat 64 i])
    (hexit :
      i = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
            BaseRegs σ E' → (impl_mul.runFrom E' ^bb12 S >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
              BaseRegs σ E' →
              (E' ⊨ [%170 := BitVec.ofNat 64 j]) → (impl_mul.runFrom E' ^bb4 S >>= g) = K) :
    (impl_mul.runFrom E ^bb10 S >>= g) = K := by
  -- if i == 0 { break; } i -= 1;
  block_init
  step_pure
  step_pure [saddOverflow_neg_one64' hi.le]
  finish_block
  case isTrue => exact hexit (eq_zero_of_ofNat64 hi hbr) E hArgs (by env_reads)
  case
    isFalse =>
    have hi1 : 1 ≤ i := by
      rcases Nat.eq_zero_or_pos i with rfl | h
      · exact absurd rfl hbr
      · exact h
    refine hback (i - 1) (by omega) E hArgs (by env_reads) ?_
    rw [← add_neg_one64 hi1 hi.le]
    env_reads

/-- An iteration of the loop at `i`: `Q` becomes `step` of it. -/
theorem main_iter (out a A b : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (hwA : DigitsA an) (hwB : DigitsB bn)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (v : Fe2625x4) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get) (hR : BaseRegs σ E)
    (hRi : E ⊨ [%170 := BitVec.ofNat 64 i]) (hF : LoopFacts S σ B out P an bn)
    (hv : S.mem.readAt σ.Q 1280 = fe4xBits v)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
            BaseRegs σ E' →
            LoopFacts S' σ B out P an bn →
            S'.mem.readAt σ.Q 1280 =
              fe4xBits
                (step (tableA P) BASEPOINT_ODD_LOOKUP_TABLE.point (digit an i) (digit bn i) v) →
            S'.alloc.nextFreeBlock =
              S.alloc.nextFreeBlock + 4 + digitBlocks 1 (digit an i) + digitBlocks 2 (digit bn i) →
            S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
            (impl_mul.runFrom E' ^bb12 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
              BaseRegs σ E' →
              (E' ⊨ [%170 := BitVec.ofNat 64 j]) →
              LoopFacts S' σ B out P an bn →
              S'.mem.readAt σ.Q 1280 =
                fe4xBits
                  (step (tableA P) BASEPOINT_ODD_LOOKUP_TABLE.point (digit an i) (digit bn i) v) →
              S'.alloc.nextFreeBlock =
                S.alloc.nextFreeBlock + 4 + digitBlocks 1 (digit an i) +
                  digitBlocks 2 (digit bn i) →
              S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
              (impl_mul.runFrom E' ^bb4 S' >>= g) = K) :
    (impl_mul.runFrom E ^bb4 S >>= g) = K := by
  refine
    headA_block out a A b σ B hσ P an bn g K i hi (hwA i hi) v S E hArgs hR hRi hF hv
      fun E₁ S₁ h₁ hR₁ hRi₁ hF₁ hv₁ ha₁ he₁ => ?_
  refine
    headB_block out a A b σ B hσ P an bn g K i hi (hwB i hi) _ S₁ E₁ h₁ hR₁ hRi₁ hF₁ hv₁
      fun E₂ S₂ h₂ hR₂ hRi₂ hF₂ hv₂ ha₂ he₂ => ?_
  refine
    tail_block out a A b σ g K i hi S₂ E₂ h₂ hR₂ hRi₂ (fun h0 E₃ h₃ hR₃ => ?_)
      fun j hj E₃ h₃ hR₃ hRi₃ => ?_
  · exact hexit h0 E₃ S₂ h₃ hR₃ hF₂ hv₂ (by omega) (by rw [he₂, he₁])
  · exact hback j hj E₃ S₂ h₃ hR₃ hRi₃ hF₂ hv₂ (by omega) (by rw [he₂, he₁])

/-- The loop from `^bb4` at `i`: `Q` the ladder from `i` down. -/
public theorem main_loop (out a A b : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (hwA : DigitsA an) (hwB : DigitsB bn)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (_ : i < 256) (v : Fe2625x4) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value out) (.value a) (.value A) (.value b)).get →
        BaseRegs σ E →
        (E ⊨ [%170 := BitVec.ofNat 64 i]) →
        LoopFacts S σ B out P an bn →
        S.mem.readAt σ.Q 1280 = fe4xBits v →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
            BaseRegs σ E' →
            LoopFacts S' σ B out P an bn →
            S'.mem.readAt σ.Q 1280 =
              fe4xBits (ladder (tableA P) BASEPOINT_ODD_LOOKUP_TABLE.point an bn i v) →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + ladderBlocks an bn i →
            S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
            (impl_mul.runFrom E' ^bb12 S' >>= g) = K) →
        (impl_mul.runFrom E ^bb4 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi v S E hArgs hR hRi hF hv hK
    exact
      main_iter out a A b σ B hσ P an bn hwA hwB g K 0 hi v S E hArgs hR hRi hF hv
        (fun _ E' S' h₁ hR' hF' hv' ha he =>
          hK E' S' h₁ hR' hF' hv'
            (by
              rw [ha]; simp only [ladderBlocks]; omega)
            he)
        fun j hj => absurd hj (by omega)
  | succ j ih =>
    intro hi v S E hArgs hR hRi hF hv hK
    refine
      main_iter out a A b σ B hσ P an bn hwA hwB g K (j + 1) hi v S E hArgs hR hRi hF hv
        (fun h => absurd h (by omega)) fun j' hj E' S' h₁ hR' hRi' hF' hv' ha he => ?_
    obtain rfl : j = j' := by omega
    refine ih (by omega) _ S' E' h₁ hR' hRi' hF' hv' fun E'' S'' h₂ hR'' hF'' hv'' ha' he' => ?_
    exact
      hK E'' S'' h₂ hR'' hF'' hv''
        (by
          rw [ha', ha]; simp only [ladderBlocks]; omega)
        (by rw [he', he])

/-! ### `Q.into()`: `split`'s limbs -/

/-- A lane's high half, `hi << 26`, in 64 bits: no overflow. -/
theorem shl26_ok (y : BitVec 32) :
    (y.setWidth 64 <<< 26) >>> 26 = y.setWidth 64 ∧
      (y.setWidth 64 <<< 26).sshiftRight 26 = y.setWidth 64 := by
  constructor <;> bv_decide

/-- A limb `lo + (hi << 26)` in 64 bits: no overflow. -/
theorem split_add_ok (y z : BitVec 32) :
    (y.setWidth 64 <<< 26).saddOverflow (z.setWidth 64) = false ∧
      (y.setWidth 64 <<< 26).uaddOverflow (z.setWidth 64) = false := by
  constructor <;> bv_decide

/-- A pair's lanes. -/
theorem ofFn_two {α : Type} (f : Fin 2 → α) : Vector.ofFn f = #v[f 0, f 1] := by
  ext i hi
  match i, hi with
  | 0, _ => rfl
  | 1, _ => rfl

attribute [local simp] shl26_ok split_add_ok ofFn_two

/-- `Q.into()`'s stores, the pairs `(X₀, X₁)`, `(X₄, Y₀)`, `(Y₄, Z₀)`, `(Z₄, T₀)` as vectors: the
point's. -/
theorem stores_eq {m : MemoryState} {p : Pointer} (ho : p.offset.toNat + 160 ≤ 2 ^ 64)
    (X Y Z T : Fin 5 → BitVec 64) :
    (((((((((((((((m.storeAt p (BitVec.packLanes #v[X 0, X 1])).storeAt (p.add 16#64) (X 2)).storeAt
                                                            (p.add 24#64) (X 3)).storeAt
                                                        (p.add 32#64)
                                                        (BitVec.packLanes #v[X 4, Y 0])).storeAt
                                                    (p.add 48#64) (Y 1)).storeAt
                                                (p.add 56#64) (Y 2)).storeAt
                                            (p.add 64#64) (Y 3)).storeAt
                                        (p.add 72#64) (BitVec.packLanes #v[Y 4, Z 0])).storeAt
                                    (p.add 88#64) (Z 1)).storeAt
                                (p.add 96#64) (Z 2)).storeAt
                            (p.add 104#64) (Z 3)).storeAt
                        (p.add 112#64) (BitVec.packLanes #v[Z 4, T 0])).storeAt
                    (p.add 128#64) (T 1)).storeAt
                (p.add 136#64) (T 2)).storeAt
            (p.add 144#64) (T 3)).storeAt
        (p.add 152#64) (T 4) =
      m.storeEdwards p ⟨X, Y, Z, T⟩ := by
  have hov (k : BitVec 64) (hk : k.toNat ≤ 112) : ¬(p.add k).offset.uaddOverflow 8#64 := by
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]
    simp
    omega
  rw [storeAt_packLanes (p := p) (by simpa using hov 0#64 (by decide)),
    storeAt_packLanes (p := p.add 32#64) (hov 32#64 (by decide)),
    storeAt_packLanes (p := p.add 72#64) (hov 72#64 (by decide)),
    storeAt_packLanes (p := p.add 112#64) (hov 112#64 (by decide))]
  simp only [MemoryState.storeEdwards, MemoryState.storeFe4, MemoryState.storeLimbs,
    Pointer.add_add, BitVec.reduceAdd]
  rfl

/-- Lane `l` of register `i` of five registers' bits. -/
theorem fe4xBits_lane' (v : Fe2625x4) (i : Fin 5) (l : Nat) (hl : l < 8) :
    (fe4xBits v).extractLsb' (256 * i + 32 * l) 32 = (v i)[l] := by
  have hr : (fe4xBits v).extractLsb' (256 * i) 256 = BitVec.packLanes (v i) := by
    fin_cases i
    · exact fe4xBits_extract_0 v
    · exact fe4xBits_extract_256 v
    · exact fe4xBits_extract_512 v
    · exact fe4xBits_extract_768 v
    · exact fe4xBits_extract_1024 v
  have h := congrArg (BitVec.extractLsb' (l * 32) 32) hr
  rw [BitVec.extractLsb'_packLanes _ _ hl, BitVec.extractLsb'_extractLsb'_add (by omega)] at h
  rw [← h]
  congr 1
  omega

/-- `fe4xBits_lane'` at a literal offset. -/
theorem fe4xBits_lane (v : Fe2625x4) (o : Nat) (h : o < 1280 ∧ o % 32 = 0) :
    (fe4xBits v).extractLsb' o 32 = (v (Fin.ofNat 5 (o / 256)))[o % 256 / 32]'(by omega) := by
  have := fe4xBits_lane' v (Fin.ofNat 5 (o / 256)) (o % 256 / 32) (by omega)
  rw [← this]
  congr 1
  simp only [Fin.val_ofNat]
  omega

theorem fin5_1 : Fin.ofNat 5 1 = 1 :=
  rfl

theorem fin5_2 : Fin.ofNat 5 2 = 2 :=
  rfl

theorem fin5_3 : Fin.ofNat 5 3 = 3 :=
  rfl

theorem fin5_4 : Fin.ofNat 5 4 = 4 :=
  rfl

/-- `split`'s limbs as the code adds them. -/
theorem split_0 (v : Fe2625x4) (i : Fin 5) :
    Fe2625x4.split v 0 i = (v i)[2].setWidth 64 <<< 26 + (v i)[0].setWidth 64 :=
  BitVec.add_comm _ _

theorem split_1 (v : Fe2625x4) (i : Fin 5) :
    Fe2625x4.split v 1 i = (v i)[3].setWidth 64 <<< 26 + (v i)[1].setWidth 64 :=
  BitVec.add_comm _ _

theorem split_2 (v : Fe2625x4) (i : Fin 5) :
    Fe2625x4.split v 2 i = (v i)[6].setWidth 64 <<< 26 + (v i)[4].setWidth 64 :=
  BitVec.add_comm _ _

theorem split_3 (v : Fe2625x4) (i : Fin 5) :
    Fe2625x4.split v 3 i = (v i)[7].setWidth 64 <<< 26 + (v i)[5].setWidth 64 :=
  BitVec.add_comm _ _

/-- Room `k` bytes into `out`'s 160. -/
theorem out_room {m : MemoryState} {p : Pointer} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) (k : BitVec 64) (w : Nat) (hk : k.toNat * 8 + w ≤ 1280)
    (hw : 0 < w := by decide) : Room m (p.add k) w :=
  Room.add_of_le
    (by
      simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega)
    hk h

/-- No wrap `k < 160` bytes into `out`. -/
theorem out_noOverflow {p : Pointer} (ho : p.offset.toNat + 160 ≤ 2 ^ 64) {k : BitVec 64}
    (hk : k.toNat < 160) : ¬p.offset.uaddOverflow k := by
  simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega

-- 33 loads and 16 stores, the shuffles' lane indices decided at each step: past the default
-- heartbeats
set_option maxHeartbeats 4000000 in
/-- `^bb12`: `Q.into()` stored at `out`, the slots' lifetimes ended; the frame from `N` on
erased. -/
public theorem exit_block (out a A b : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (N : Nat) (hN : N ≤ B.alloc.nextFreeBlock)
    (v : Fe2625x4) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get) (hR : BaseRegs σ E)
    (hF : LoopFacts S σ B out P an bn) (hv : S.mem.readAt σ.Q 1280 = fe4xBits v) :
    (impl_mul.runFrom E ^bb12 S >>= fun p =>
        PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom N } : GlobalState))) =
      .value
        (.nil,
          ({ alloc := S.alloc, mem := (S.mem.eraseFrom N).storeEdwards out (toEdwards v) } :
            GlobalState)) := by
  rcases σ with
    ⟨idp, selBm, sumBm, selBp, sumBp, selAm, sumAm, selAp, sumAp, dbl, Q, table_A, b_naf, a_naf⟩
  obtain ⟨hwf, hout, hout_off, hsl, hQF, haF, haR, hbF, hbR, houtLt, htAF, htAR⟩ := hF
  open_slots hσ
  have hQ_off : Q.offset = 0 := by
    rw [hQ]; rfl
  clear haF haR hbF hbR htAF htAR hsl
  have ho0 : Room S.mem out 128 := hout.mono (by omega)
  have ho16 := out_room hout hout_off 16#64 64 (by decide)
  have ho24 := out_room hout hout_off 24#64 64 (by decide)
  have ho32 := out_room hout hout_off 32#64 128 (by decide)
  have ho48 := out_room hout hout_off 48#64 64 (by decide)
  have ho56 := out_room hout hout_off 56#64 64 (by decide)
  have ho64 := out_room hout hout_off 64#64 64 (by decide)
  have ho72 := out_room hout hout_off 72#64 128 (by decide)
  have ho88 := out_room hout hout_off 88#64 64 (by decide)
  have ho96 := out_room hout hout_off 96#64 64 (by decide)
  have ho104 := out_room hout hout_off 104#64 64 (by decide)
  have ho112 := out_room hout hout_off 112#64 128 (by decide)
  have ho128 := out_room hout hout_off 128#64 64 (by decide)
  have ho136 := out_room hout hout_off 136#64 64 (by decide)
  have ho144 := out_room hout hout_off 144#64 64 (by decide)
  have ho152 := out_room hout hout_off 152#64 64 (by decide)
  -- let tmp = Q.0.split();
  block_init
  step_load
  step_pure
  step_load
  step_pure
  step_load
  iterate 2 step_pure
  step_load
  step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 8 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 10 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 10 step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  iterate 2 step_pure
  step_load
  step_pure
  step_load
  iterate 11 step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  iterate 7 step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  iterate 9 step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  iterate 9 step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  iterate 3 step_pure
  finish_block
  subst hS
  simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
    MemoryState.eraseFrom_storeAt]
  generalize S.mem.eraseFrom N = m
  simp (disch := decide) only [fe4xBits_lane, Nat.reduceDiv, Nat.reduceMod, fin5_1, fin5_2, fin5_3,
    fin5_4]
  simp only [← split_0, ← split_1, ← split_2, ← split_3]
  rw [stores_eq hout_off (Fe2625x4.split v 0) (Fe2625x4.split v 1) (Fe2625x4.split v 2)
      (Fe2625x4.split v 3)]
  rfl

end MLIR.Agave.Avx2.impl_mul
