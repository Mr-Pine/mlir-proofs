module

public import Firedancer.Lane.Common.DecodeStaged
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow
public import Firedancer.Lane.Mlir.decode_stage_sqr_cnt
public import MLIR.Run.Tactic
import Std.Tactic.BVDecide
import Mathlib.Tactic.IntervalCases

namespace MLIR.Firedancer.Lane.fd_r43x6_ge_decode_step_slow

open Firedancer.Avx512

/-- `decode_stage.sqr_cnt`'s initializer gives its constant, leaving the state. -/
public theorem sqr_cnt_value_eq (s : GlobalState) :
    _root_.Firedancer.Lane.Mlir.decode_stage_sqr_cnt.value s =
      .value (Ty.wrap _root_.Firedancer.Lane.Mlir.decode_stage_sqr_cnt.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- The lift's registers' context. -/
local notation "Γ" => _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow.Γ

/-- The lift's run from a block. -/
local notation "runS" => _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow.runFrom

/-- Register `k`, its type from the lift's proof (deciding it would unfold `Γ`). -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow.hty $k)

@[expose] public section

/-- The arguments. -/
abbrev argsOf (st : Pointer) (n : BitVec 64) : Vals (Ctx.args Γ) :=
  _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow.args (.value st) (.value n)

/-- The entry blocks' registers the loop reads: the table, the constants, the fields' pointers. -/
abbrev Regs (st tbl : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value tbl, %1 := .value 2#64, %2 := Ty.wrap foldK, %3 := Ty.wrap foldShifts, %4 :=
    Ty.wrap foldMask, %5 := Ty.wrap (Vector.replicate 8 24), %6 := Ty.wrap (Vector.replicate 8 7),
    %7 := Ty.wrap #v[-1, -1, -1, -1, -1, -1, 0, 0], %15 := .value 0#64, %16 := .value 12#64, %17 :=
    .value 1#64, %18 := .value 18446744073709551614#64, %20 := Ty.wrap sqrDbl0, %21 :=
    Ty.wrap sqrDbl2, %22 := Ty.wrap sqrDbl4, %23 := Ty.wrap (Vector.replicate 8 0), %24 :=
    Ty.wrap (Vector.replicate 8 9), %25 := Ty.wrap sqrMaskN1, %26 := Ty.wrap sqrMaskN2, %28 :=
    .value 18446744073709551615#64, %38 := lanesBelow 6 sqrMask1, %46 := lanesBelow 6 sqrMask2,
    %54 := lanesBelow 5 sqrMask1, %62 := lanesBelow 5 sqrMask2, %70 := lanesFrom 7 wwl_zero, %78 :=
    lanesBelow 5 wwl_zero, %86 := lanesFrom 6 wwl_zero, %94 := lanesFrom 5 wwl_zero, %102 :=
    lanesBelow 3 wwl_zero, %110 := lanesFrom 4 wwl_zero, %118 := lanesBelow 2 wwl_zero, %126 :=
    lanesFrom 3 wwl_zero, %134 := lanesBelow 1 wwl_zero, %142 := lanesFrom 2 wwl_zero, %143 :=
    .value (st.add 704#64), %145 := .value (st.add 712#64), %146 := .value (st.add 384#64), %147 :=
    .value (st.add 64#64), %148 := .value (st.add 320#64), %149 := .value (st.add 256#64), %150 :=
    .value (st.add 192#64), %151 := .value (st.add 128#64)]

/-- The squarings' registers: the stage `s`, the count `n`, `rem` and `k = min(rem, n)`. -/
abbrev SqrRegs (st tbl : Pointer) (s n r k : BitVec 64) (E : ⟪Γ⟫) : Prop :=
  Regs st tbl E ∧ E ⊨ [%153 := .value s, %154 := .value n, %156 := .value r, %157 := .value k]

variable (st tbl : Pointer) (n₀ s n r k : BitVec 64) (K : PoisonOr (Vals [] × GlobalState))

/-- `^bb7`: one squaring of `x`, `k` odd; on to `^bb8`. -/
theorem bb7 (hk : k.setWidth 1 = 1#1) (x : Wwl) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = (argsOf st n₀).get)
    (hR : SqrRegs st tbl s n r k E) (hX : E ⊨ [%164 := x])
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (argsOf st n₀).get → SqrRegs st tbl s n r k E' →
        E' ⊨ [%213 := fd_r43x6_sqr x] → runS E' 8 S = K) :
    runS E 7 S = K := by
  dsimp only [SqrRegs, Regs] at hR
  casesm* _ ∧ _
  block_init
  step_pure
  step_pure [hk]
  step_pattern using runBodyFrom_r43SqrRun with x1
  finish_block
  step_loop using hK

/-- The pairs' counter, `i + 2`. -/
theorem add2_eq (i : Nat) : BitVec.ofNat 64 i + 2#64 = BitVec.ofNat 64 (i + 2) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
  omega

/-- The pairs' counter at the last pair is the even count. -/
theorem add2_last {i : Nat} {c : BitVec 64} (h : i + 2 * (0 + 1) = c.toNat) :
    BitVec.ofNat 64 (i + 2) = c := by
  apply BitVec.eq_of_toNat_eq
  have := c.isLt
  rw [BitVec.toNat_ofNat]
  omega

/-- The pairs' counter before the last pair is not the even count. -/
theorem add2_ne {i r : Nat} {c : BitVec 64} (h : i + 2 * (r + 1 + 1) = c.toNat) :
    BitVec.ofNat 64 (i + 2) ≠ c := by
  intro h'
  have := c.isLt
  have := congrArg BitVec.toNat h'
  rw [BitVec.toNat_ofNat] at this
  omega

/-- `^bb9`: `r + 1` more pairs of squarings of `x`, the counter `i` up to the even count `c`; then
`^bb6` with the result in `%312`. -/
theorem loop9 (S : GlobalState) (c : BitVec 64) :
    ∀ q (x : Wwl) (i : Nat) (E : ⟪Γ⟫), E.args = (argsOf st n₀).get →
      SqrRegs st tbl s n r k E →
      E ⊨ [%160 := .value (k &&& 1#64), %162 := .value c, %217 := x, %218 :=
        .value (BitVec.ofNat 64 i)] →
      i + 2 * (q + 1) = c.toNat →
      (∀ E' : ⟪Γ⟫, E'.args = (argsOf st n₀).get → SqrRegs st tbl s n r k E' →
        E' ⊨ [%160 := .value (k &&& 1#64), %312 := sqrPairs q x] → runS E' 6 S = K) →
      runS E 9 S = K := by
  intro q
  induction q with
  | zero =>
    intro x i E hA hR hX hc hK
    dsimp only [SqrRegs, Regs] at hR
    casesm* _ ∧ _
    block_init
    step_pattern using runBodyFrom_r43SqrRun with x1
    step_pattern using runBodyFrom_r43SqrRun with x2
    step_pure [add2_eq]
    step_pure
    finish_block
    · step_loop using hK
      rfl
    · exact absurd (add2_last hc) hbr
  | succ q ih =>
    intro x i E hA hR hX hc hK
    dsimp only [SqrRegs, Regs] at hR
    casesm* _ ∧ _
    block_init
    step_pattern using runBodyFrom_r43SqrRun with x1
    step_pattern using runBodyFrom_r43SqrRun with x2
    step_pure [add2_eq]
    step_pure
    finish_block
    · exact absurd hbr (add2_ne hc)
    · step_loop using ih x2 (i + 2)
      intro hR' hX'
      rw [hx2, hx1] at hX'
      rw [hS]
      exact hK _ hArgs₀ hR' hX'

/-- A squaring after `a`: `a + 1`. -/
theorem sqrN_succ' : ∀ (a : Nat) (x : Wwl),
    Avx512.fd_r43x6_repsqr_mul2.sqrN (a + 1) x = fd_r43x6_sqr (Avx512.fd_r43x6_repsqr_mul2.sqrN a x)
  | 0, _ => rfl
  | a + 1, x => sqrN_succ' a (fd_r43x6_sqr x)

/-- The count's even part. -/
theorem and_m2_toNat (k : BitVec 64) :
    (k &&& 18446744073709551614#64).toNat = k.toNat - k.toNat % 2 := by
  have h1 : k &&& 18446744073709551614#64 = k - k % 2#64 := by bv_decide
  have h2 : (k % 2#64).toNat = k.toNat % 2 := by simp [BitVec.toNat_umod]
  rw [h1, BitVec.toNat_sub_of_le (by bv_decide), h2]

/-- `and_m2_toNat` as the steps leave it. -/
theorem and_m2_nat (k : BitVec 64) : k.toNat &&& 18446744073709551614 = k.toNat - k.toNat % 2 := by
  have := and_m2_toNat k
  simpa [BitVec.toNat_and] using this

/-- The count's low bit. -/
theorem and_one_toNat (k : BitVec 64) : (k &&& 1#64).toNat = k.toNat % 2 := by
  have h1 : k &&& 1#64 = k % 2#64 := by bv_decide
  rw [h1]
  simp [BitVec.toNat_umod]

/-- An odd count's low bit, as `trunc` reads it. -/
theorem odd_trunc {k : BitVec 64} (h : ¬k &&& 1#64 = 0#64) : k.setWidth 1 = 1#1 := by bv_decide

/-- `min(rem, n)` of a zero `rem`. -/
theorem umin_zero (n : BitVec 64) : (if (0#64).ult n then 0#64 else n) = 0#64 ∨ n = 0#64 := by
  by_cases h : (0#64).ult n <;> simp [h]
  bv_decide

/-- `min(rem, n)` of nonzero `rem` and `n`, not `1`: at least two. -/
theorem umin_ge2 {r n k : BitVec 64} (hr : ¬r = 0#64) (hn : n ≠ 0)
    (hk : k = if r.ult n then r else n)
    (h1 : ¬k = 1#64) : 2 ≤ k.toNat := by
  have h0 : k ≠ 0#64 := by
    rw [hk]
    split <;> assumption
  have : k.toNat ≠ 0 := fun h => h0 (BitVec.eq_of_toNat_eq h)
  have : k.toNat ≠ 1 := fun h => h1 (BitVec.eq_of_toNat_eq h)
  omega

/-- `^bb3` to `^bb8`: `k = min(rem, n)` squarings of the accumulator `x`, `rem` and `x` read from
the state: two at a time, then one if `k` is odd. -/
theorem sqrPhase (x : Wwl) (hn : n ≠ 0) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = (argsOf st n₀).get) (hR : Regs st tbl E)
    (hX : E ⊨ [%153 := .value s, %154 := .value n]) (hfr : Fits S.mem (st.add 712#64) 64)
    (hrr : S.mem.readAt (st.add 712#64) 64 = r) (hfx : Fits S.mem st 512)
    (hrx : S.mem.readAt st 512 = BitVec.packLanes x)
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (argsOf st n₀).get →
        SqrRegs st tbl s n r (if r.ult n then r else n) E' →
        E' ⊨ [%213 := Avx512.fd_r43x6_repsqr_mul2.sqrN (if r.ult n then r else n).toNat x] →
        runS E' 8 S = K) :
    runS E 3 S = K := by
  dsimp only [Regs] at hR
  casesm* _ ∧ _
  block_init
  step_load with r'
  step_pure with k
  step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with x'
  step_pure
  finish_block
  · -- `rem = 0`: no squarings
    step_loop using hK
    rcases umin_zero n with h | h
    · rw [h]
      rfl
    · exact absurd h hn
  · have hr0 := hbr
    block_init
    step_pure
    step_pure
    finish_block
    · -- `k = 1`: one squaring
      step_loop using bb7 st tbl n₀ s n r k K (by rw [hbr]; decide) x
      intro hR' hX'
      rw [hS]
      refine hK _ hArgs₀ (hk ▸ hR') ?_
      rw [← hk, hbr]
      exact hX'
    · -- the pairs, then one more if `k` is odd
      block_init
      step_pure
      finish_block
      have h2 := umin_ge2 hr0 hn hk hbr
      step_loop using loop9 st tbl n₀ s n r k K S (k &&& 18446744073709551614#64)
        (k.toNat / 2 - 1) x 0
      · rw [← hk, and_m2_nat]
        omega
      intro hR' hX'
      subst hk
      block_init
      step_pure
      finish_block
      · -- even
        step_loop using hK
        rw [sqrPairs_eq]
        congr 2
        have := and_one_toNat (if r.ult n = true then r else n)
        rw [hbr] at this
        simp at this
        omega
      · -- odd
        step_loop using bb7 st tbl n₀ s n r _ K (odd_trunc hbr) (sqrPairs _ x)
        intro hR'' hX''
        rw [hS]
        refine hK _ hArgs₀ hR'' ?_
        rw [hX'', sqrPairs_eq, ← sqrN_succ']
        congr 2
        have := and_one_toNat (if r.ult n = true then r else n)
        rw [BitVec.toNat_eq] at hbr
        simp at hbr this
        omega

/-- `sqr_cnt[ i ]` read from the global's block. -/
theorem readAt_sqrCnt {m : MemoryState} {p : Pointer} {hw : (Ty.array 12 (.bv 64)).width = 768}
    (hf : Fits m p 768) (ho : p.offset = 0)
    (h : m.readAt p 768 =
      Ty.flatBits _root_.Firedancer.Lane.Mlir.decode_stage_sqr_cnt.lit (hw := hw))
    {i : Nat} (hi : i < 12) :
    m.readAt (p.add (BitVec.ofNat 64 (i * 8))) 64 = sqrCnt (BitVec.ofNat 64 i) := by
  have hs : (Ty.bv 64).stride = 64 := rfl
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      h,
    Ty.flatBits_eq, BitVec.extractLsb'_cast,
    show (BitVec.ofNat 64 (i * 8)).toNat * 8 = i * 64 by
      simp; omega,
    Ty.extractLsb'_flattenRaw_array _
      (by
        rw [hs]; omega)
      (by
        rw [hs, Nat.mul_mod_left]; decide)]
  simp only [hs, Nat.mul_mod_left, Nat.mul_div_cancel _ (by decide : 0 < 64),
    Ty.extractLsb'_flattenRaw_bv, BitVec.extractLsb'_eq_self]
  interval_cases i <;> rfl

/-- `sqr_cnt[ i ]` is known. -/
theorem fits_sqrCnt {m : MemoryState} {p : Pointer} (hf : Fits m p 768) (ho : p.offset = 0)
    {i : Nat} (hi : i < 12) : Fits m (p.add (BitVec.ofNat 64 (i * 8))) 64 :=
  hf.add_of_le (by simp [BitVec.uaddOverflow, ho]; omega) (by simp; omega)

/-- The stage's count `s + 1` (`add nuw nsw`) does not overflow. -/
theorem add1_ok {s : BitVec 64} (h : s.toNat ≤ 11) :
    s.saddOverflow 1#64 = false ∧ s.uaddOverflow 1#64 = false := by
  have : s < 12#64 := by
    rw [BitVec.lt_def]
    simp
    omega
  constructor <;> bv_decide

variable {hw : (Ty.array 12 (.bv 64)).width = 768}

variable (hw) in
/-- `^bb2` with at most `f` more times round: the loop runs `stepSlowF f` on the state `D` at `st`,
the state over `m₀`. -/
abbrev Outer (m₀ : MemoryState) (f : Nat) : Prop :=
  ∀ (D : DecSt) (n : BitVec 64) (E : ⟪Γ⟫) (S : GlobalState) (a : AllocState),
    E.args = (argsOf st n₀).get → Regs st tbl E → E ⊨ [%153 := .value D.stage, %154 := .value n] →
    n ≠ 0 → D.Ok → 12 - D.stage.toNat < f → S.mem = m₀.storeDec st D → S.alloc = a → S.WF →
    Fits S.mem tbl 768 →
    S.mem.readAt tbl 768 = Ty.flatBits _root_.Firedancer.Lane.Mlir.decode_stage_sqr_cnt.lit
      (hw := hw) →
    runS E 2 S = .value (.nil, ⟨a, m₀.storeDec st (D.stepSlowF f n)⟩)

/-- `^bb25`, `^bb26`: `rem` stored, `n` counted down for the multiply; out if it is used up, else
round again. -/
theorem tail25 (hne : st.id ≠ tbl.id) (m₀ : MemoryState) (hroom : m₀.DecRoom st) (f : Nat)
    (ih : Outer st tbl n₀ hw m₀ f)
    (D : DecSt) (r0 n1 : BitVec 64) (E : ⟪Γ⟫) (S : GlobalState) (a : AllocState)
    (hA : E.args = (argsOf st n₀).get) (hR : Regs st tbl E)
    (hX : E ⊨ [%%904 := .value D.stage, %%905 := .value D.rem, %215 := .value n1]) (hOk : D.Ok)
    (hf : 12 - D.stage.toNat < f) (hm : S.mem = m₀.storeDec st { D with rem := r0 })
    (ha : S.alloc = a) (hwf : S.WF) (htf : Fits S.mem tbl 768)
    (htr : S.mem.readAt tbl 768 = Ty.flatBits _root_.Firedancer.Lane.Mlir.decode_stage_sqr_cnt.lit
      (hw := hw)) :
    runS E 25 S = .value (.nil, ⟨a, m₀.storeDec st (D.stepSlowF f (n1 - 1))⟩) := by
  dsimp only [Regs] at hR
  casesm* _ ∧ _
  have h712 : ¬st.offset.uaddOverflow 712#64 := BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
  have hst712 : Room S.mem (st.add 712#64) 64 := by
    rw [hm, Room.storeDec_iff]
    exact decRoom_room hroom _ _
  have hmem : S.mem.storeAt (st.add 712#64) D.rem = m₀.storeDec st D := by
    rw [hm, MemoryState.storeDec_storeAt_rem hroom.1]
  have hsub : n1 + 18446744073709551615#64 = n1 - 1 := by
    rw [BitVec.sub_eq_add_neg]
    rfl
  block_init
  step_store
  step_pure
  finish_block
  rw [← hsub]
  block_init
  step_pure
  finish_block
  · block_init
    finish_block
    rw [hbr, DecSt.stepSlowF_zero, hS, hmem, ha]
  · step_loop using ih D (n1 + 18446744073709551615#64) _ _ a

/-- The next stage's count: `sqr_cnt[ s + 1 ]` for `s ≤ 10`. -/
theorem stageOp_rem {D : DecSt} (hs : D.stage.toNat ≤ 10) :
    D.stageOp.rem = sqrCnt (BitVec.ofNat 64 ((D.stage.toNat + 1) % 18446744073709551616)) := by
  have e : (D.stage + 1).toNat = D.stage.toNat + 1 := by
    rw [BitVec.toNat_add]
    simp
    omega
  have hlt : D.stage + 1 < 12 := by
    rw [BitVec.lt_def, e]
    simp
    omega
  simp only [DecSt.stageOp, DecSt.stageMul_stage, hlt, ite_true]
  congr 1
  apply BitVec.eq_of_toNat_eq
  rw [e]
  simp
  omega

/-- `^bb24`: `decode_stage`'s end for stages `0 … 10`: the product stored as `x` and `m`, the stage
counted, its squarings read from `sqr_cnt`; on to `^bb25`. -/
theorem tail24 (hne : st.id ≠ tbl.id) (hto : tbl.offset = 0#64) (m₀ : MemoryState)
    (hroom : m₀.DecRoom st) (f : Nat) (ih : Outer st tbl n₀ hw m₀ f) (D : DecSt) (n1 : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) (a : AllocState) (hA : E.args = (argsOf st n₀).get)
    (hR : Regs st tbl E)
    (hX : E ⊨ [%153 := .value D.stage, %215 := .value n1, %%900 := D.stageMul.x])
    (hs : D.stage.toNat ≤ 10) (hOk : D.stageOp.Ok) (hf : 12 - D.stageOp.stage.toNat < f)
    (hm : S.mem = m₀.storeDec st D.preStage) (ha : S.alloc = a) (hwf : S.WF)
    (htf : Fits S.mem tbl 768)
    (htr : S.mem.readAt tbl 768 = Ty.flatBits _root_.Firedancer.Lane.Mlir.decode_stage_sqr_cnt.lit
      (hw := hw)) :
    runS E 24 S = .value (.nil, ⟨a, m₀.storeDec st (D.stageOp.stepSlowF f (n1 - 1))⟩) := by
  dsimp only [Regs] at hR
  casesm* _ ∧ _
  have h64 : ¬st.offset.uaddOverflow 64#64 := BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
  have h704 : ¬st.offset.uaddOverflow 704#64 := BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
  have hst0 : Room S.mem st 512 := by
    rw [hm, Room.storeDec_iff]
    exact hroom.2.mono (by decide)
  have hst64 : Room S.mem (st.add 64#64) 512 := by
    rw [hm, Room.storeDec_iff]
    exact decRoom_room hroom _ _
  have hst704 : Room S.mem (st.add 704#64) 64 := by
    rw [hm, Room.storeDec_iff]
    exact decRoom_room hroom _ _
  have hmem :
      ((S.mem.storeAt st (BitVec.packLanes D.stageMul.x)).storeAt (st.add 64#64)
            (BitVec.packLanes D.stageMul.x)).storeAt (st.add 704#64) (D.stage + 1#64) =
        m₀.storeDec st { D.stageOp with rem := D.rem } := by
    rw [hm, MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_m hroom.1,
      MemoryState.storeDec_storeAt_stage hroom.1, ← DecSt.preStage_stores]
    rfl
  have hi : (D.stage.toNat + 1) % 18446744073709551616 < 12 := by omega
  have hfc := fits_sqrCnt htf hto hi
  have hrc := readAt_sqrCnt htf hto htr hi
  rw [← stageOp_rem hs] at hrc
  block_init
  step_store
  step_store
  step_pure [(add1_ok (s := D.stage) (by omega)).1, (add1_ok (s := D.stage) (by omega)).2]
  step_store
  step_pure
  step_load
  finish_block
  step_loop using tail25 st tbl n₀ hne m₀ hroom f ih D.stageOp D.rem n1 _ _ a
  rw [show D.stageOp.stage = D.stageMul.stage + 1 from rfl, DecSt.stageMul_stage]
  rfl

/-- `rem > n` leaves nothing of `n` after `k = min(rem, n)` squarings. -/
theorem ugt_k {r n k : BitVec 64} (hk : (if r.ult n = true then r else n) = k)
    (h : n.ult r = true) : n - k = 0#64 := by
  subst hk
  have : ¬r.ult n = true := by bv_decide
  simp [this]

/-- `rem ≤ n`: `k = min(rem, n)` uses up `rem`. -/
theorem rem_k {D : DecSt} {n k : BitVec 64} (hk : (if D.rem.ult n = true then D.rem else n) = k)
    (h : ¬n.ult D.rem = true) : (D.sqrs k).rem = 0 := by
  subst hk
  simp only [DecSt.sqrs]
  split
  · exact BitVec.sub_self _
  · have : D.rem = n := by bv_decide
    rw [this, BitVec.sub_self]
    rfl

/-- The fuel left after a stage's end. -/
theorem hf_next {D : DecSt} {f : Nat} (k : BitVec 64) (hf : 12 - D.stage.toNat < f + 1)
    (hlt : D.stage < 12) : 12 - (D.sqrs k).stageOp.stage.toNat < f := by
  have h := BitVec.lt_def.1 hlt
  have h12 : (12 : BitVec 64).toNat = 12 := rfl
  show 12 - ((D.sqrs k).stageMul.stage + 1).toNat < f
  rw [show (D.sqrs k).stageMul.stage = D.stage from (D.sqrs k).stageMul_stage, BitVec.toNat_add]
  simp
  omega

-- the loop's body in one proof, its twelve stage cases each a walk: over 200000 heartbeats
set_option maxHeartbeats 4000000 in
/-- `^bb2`'s loop: at most `f` more times round. -/
theorem outer (hne : st.id ≠ tbl.id) (hto : tbl.offset = 0#64) (m₀ : MemoryState)
    (hroom : m₀.DecRoom st) : ∀ f, Outer st tbl n₀ hw m₀ f := by
  intro f
  induction f with
  | zero =>
    intro D n E S a _ _ _ _ _ hf
    omega
  | succ f ih =>
    intro D n E S a hA hR hX hn hOk hf hm ha hwf htf htr
    have hD := hm ▸ MemoryState.DecHolds.storeDec (D := D) hroom
    obtain ⟨⟨fx, rx⟩, -, -, -, -, -, -, -, -, -, -, -, ⟨fr, rr⟩, -⟩ := hD
    have hR' := hR
    dsimp only [Regs] at hR'
    casesm* _ ∧ _
    block_init
    step_pure
    finish_block
    · -- `stage < 12`: the squarings
      step_loop using sqrPhase st tbl n₀ D.stage n D.rem _ D.x hn
      intro hR8 hX8
      have hlt : D.stage < 12 := BitVec.ult_iff_lt.1 hbr
      generalize hk : (if D.rem.ult n = true then D.rem else n) = k at hR8 hX8
      dsimp only [SqrRegs, Regs] at hR8
      casesm* _ ∧ _
      rw [← hS] at hm ha
      have hst0 : Room S.mem st 512 := by
        rw [hm, Room.storeDec_iff]
        exact hroom.2.mono (by decide)
      have h712 : ¬st.offset.uaddOverflow 712#64 :=
        BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
      have hst712 : Room S.mem (st.add 712#64) 64 := by
        rw [hm, Room.storeDec_iff]
        exact decRoom_room hroom _ _
      have hmem :
          (S.mem.storeAt st
                (BitVec.packLanes (Avx512.fd_r43x6_repsqr_mul2.sqrN k.toNat D.x))).storeAt
              (st.add 712#64) (D.rem - k) = m₀.storeDec st (D.sqrs k) := by
        rw [hm, MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1]
        rfl
      block_init
      step_store
      step_pure
      step_store
      step_pure
      step_pure
      finish_block
      · -- `n` used up by the squarings: done
        block_init
        finish_block
        rw [DecSt.stepSlowF_sqrs f hn hlt hk hbr]
        rw [hS] at ha ⊢
        rw [hmem, ← ha]
      · have hn1 := hbr
        block_init
        step_pure
        finish_block
        · -- `rem > n`: then `k = n`, used up
          exact absurd (ugt_k hk hbr) hn1
        · -- `rem ≤ n`: the stage's end
          have hle := hbr
          have hspec := DecSt.stepSlowF_stage f hn hlt hk hn1 (rem_k hk hle)
          rw [hS] at ha
          have hm1 : S.mem = m₀.storeDec st (D.sqrs k) := by rw [hS, ← hmem]
          have hD1 := hm1 ▸ MemoryState.DecHolds.storeDec (D := D.sqrs k) hroom
          have h192 : ¬st.offset.uaddOverflow 192#64 :=
            BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
          rw [hspec]
          block_init
          finish_block
          · -- stage 0: `z2 = x`
            have hst192 : Room S.mem (st.add 192#64) 512 := by
              rw [hm1, Room.storeDec_iff]
              exact decRoom_room hroom _ _
            clear hD1
            block_init
            step_store
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1,
                MemoryState.storeDec_storeAt_z2 hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr]
              rfl
            simp only [DecSt.stageMul, DecSt.sqrs, hbr]
            rfl
          · -- stage 1: `x = x z`, kept as `z9`
            have hF := hD1.2.2.1
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            have h256 : ¬st.offset.uaddOverflow 256#64 :=
              BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
            have hst256 : Room S.mem (st.add 256#64) 512 := by
              rw [hm1, Room.storeDec_iff]
              exact decRoom_room hroom _ _
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            step_store
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1,
                MemoryState.storeDec_storeAt_z9 hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
          · -- stage 2: `x = x z2`
            obtain ⟨w0, hw0⟩ := Option.isSome_iff_exists.1 (hOk.1 (by rw [hbr]; decide))
            have hF : Fits S.mem (st.add 192#64) 512 ∧
                S.mem.readAt (st.add 192#64) 512 = BitVec.packLanes w0 := by
              have h := hD1.2.2.2.1
              rwa [show (D.sqrs k).z2 = D.z2 from rfl, hw0] at h
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, hw0, BitVec.toNat_ofNat,
                Option.getD_some]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, hw0, BitVec.toNat_ofNat,
              Option.getD_some]
          · -- stage 3: `x = x z9`
            obtain ⟨w0, hw0⟩ := Option.isSome_iff_exists.1 (hOk.2.1 (by rw [hbr]; decide))
            have hF : Fits S.mem (st.add 256#64) 512 ∧
                S.mem.readAt (st.add 256#64) 512 = BitVec.packLanes w0 := by
              have h := hD1.2.2.2.2.1
              rwa [show (D.sqrs k).z9 = D.z9 from rfl, hw0] at h
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, hw0, BitVec.toNat_ofNat,
                Option.getD_some]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, hw0, BitVec.toNat_ofNat,
              Option.getD_some]
          · -- stage 4: `x = x m`, kept as `z2e10m1`
            have hF := hD1.2.1
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            have h320 : ¬st.offset.uaddOverflow 320#64 :=
              BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
            have hst320 : Room S.mem (st.add 320#64) 512 := by
              rw [hm1, Room.storeDec_iff]
              exact decRoom_room hroom _ _
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            step_store
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1,
                MemoryState.storeDec_storeAt_z2e10m1 hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
          · -- stage 5: `x = x m`
            have hF := hD1.2.1
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
          · -- stage 6: `x = x m`
            have hF := hD1.2.1
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
          · -- stage 7: `x = x z2e10m1`, kept as `z2e50m1`
            obtain ⟨w0, hw0⟩ := Option.isSome_iff_exists.1 (hOk.2.2.1 (by rw [hbr]; decide))
            have hF : Fits S.mem (st.add 320#64) 512 ∧
                S.mem.readAt (st.add 320#64) 512 = BitVec.packLanes w0 := by
              have h := hD1.2.2.2.2.2.1
              rwa [show (D.sqrs k).z2e10m1 = D.z2e10m1 from rfl, hw0] at h
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            have h384 : ¬st.offset.uaddOverflow 384#64 :=
              BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
            have hst384 : Room S.mem (st.add 384#64) 512 := by
              rw [hm1, Room.storeDec_iff]
              exact decRoom_room hroom _ _
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            step_store
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1,
                MemoryState.storeDec_storeAt_z2e50m1 hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, hw0, BitVec.toNat_ofNat,
                Option.getD_some]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, hw0, BitVec.toNat_ofNat,
              Option.getD_some]
          · -- stage 8: `x = x m`
            have hF := hD1.2.1
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
          · -- stage 9: `x = x m`
            have hF := hD1.2.1
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, BitVec.toNat_ofNat]
          · -- stage 10: `x = x z2e50m1`
            obtain ⟨w0, hw0⟩ := Option.isSome_iff_exists.1 (hOk.2.2.2 (by rw [hbr]; decide))
            have hF : Fits S.mem (st.add 384#64) 512 ∧
                S.mem.readAt (st.add 384#64) 512 = BitVec.packLanes w0 := by
              have h := hD1.2.2.2.2.2.2.1
              rwa [show (D.sqrs k).z2e50m1 = D.z2e50m1 from rfl, hw0] at h
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            finish_block
            step_loop using tail24 st tbl n₀ hne hto m₀ hroom f ih (D.sqrs k) (n - k) _ _ a
            case hs => rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, hbr]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1]
              simp only [DecSt.preStage, DecSt.stageMul, DecSt.sqrs, hbr, hw0, BitVec.toNat_ofNat,
                Option.getD_some]
            simp only [DecSt.stageMul, DecSt.sqrs, hbr, hw0, BitVec.toNat_ofNat,
              Option.getD_some]
          · -- stage 11 (the default): `t0 = x z`
            have h11 : D.stage = 11#64 := by
              have := BitVec.lt_def.1 hlt
              have h12 : (12 : BitVec 64).toNat = 12 := rfl
              bv_omega
            have hF := hD1.2.2.1
            obtain ⟨hFf, hFr⟩ := hF
            clear hD1
            have h64 : ¬st.offset.uaddOverflow 64#64 :=
              BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
            have h704 : ¬st.offset.uaddOverflow 704#64 :=
              BitVec.not_uaddOverflow_of_le hroom.1 (by decide)
            have hst64 : Room S.mem (st.add 64#64) 512 := by
              rw [hm1, Room.storeDec_iff]
              exact decRoom_room hroom _ _
            have hst704 : Room S.mem (st.add 704#64) 64 := by
              rw [hm1, Room.storeDec_iff]
              exact decRoom_room hroom _ _
            have hadd := add1_ok (s := D.stage) (by rw [h11]; decide)
            block_init
            step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with w1
            step_pattern using runBodyFrom_mulRun with x2
            step_store
            step_store
            step_pure [hadd.1, hadd.2]
            step_store
            finish_block
            step_loop using tail25 st tbl n₀ hne m₀ hroom f ih (D.sqrs k).stageOp (D.sqrs k).rem
              (n - k) _ _ a
            case hOk =>
              exact (hOk.sqrs k).stageOp
                (by rw [show (D.sqrs k).stage = D.stage from rfl, h11]; decide)
            case hf => exact hf_next k hf hlt
            case hm =>
              rw [MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_rem hroom.1,
                MemoryState.storeDec_storeAt_x hroom.1, MemoryState.storeDec_storeAt_m hroom.1,
                MemoryState.storeDec_storeAt_stage hroom.1]
              simp only [DecSt.stageOp, DecSt.stageMul, DecSt.sqrs, h11, BitVec.toNat_ofNat]
              rfl
            all_goals
              simp only [DecSt.stageOp, DecSt.stageMul, DecSt.sqrs, h11, BitVec.toNat_ofNat]
              rfl
    · -- `stage ≥ 12`: done
      block_init
      finish_block
      have hlt : ¬D.stage < 12 := fun h => hbr (BitVec.ult_iff_lt.2 h)
      simp only [DecSt.stepSlowF, hlt, and_false, ite_false]
      rw [← hm, ← ha]

end

-- the entry block's constants and the loop's lemma application: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r43x6_ge_decode_step_slow( st, n )` stores `D.stepSlow n` over the state `D` at `st`, the
named multipliers its stages need set. -/
public theorem call_eq (st : Pointer) (n : BitVec 64) (D : DecSt) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow.globals)
    (hst : s.mem.DecRoom st) (hD : s.mem.DecHolds st D) (hOk : D.Ok) :
    _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow.call (argsOf st n) s =
      .value (.nil, { s with mem := s.mem.storeDec st (D.stepSlow n) }) := by
  have hself := MemoryState.storeDec_self hD
  obtain ⟨-, -, -, -, -, -, -, -, -, -, -, ⟨fs, rs⟩, -, -⟩ := hD
  generalize hR : D.stepSlow n = R
  func_init
  block_init
  step_addressof sqr_cnt_value_eq with tbl
  iterate 30 step_pure
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 6 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 4 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 1 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 2 wwl_zero)
  step_pure
  step_pure
  finish_block
  · -- `n = 0`: nothing to do
    block_init
    finish_block
    rw [← hR, hbr, DecSt.stepSlow, DecSt.stepSlowF_zero, ← hS, hself]
  · block_init
    iterate 7 step_pure
    step_load
    finish_block
    subst hS
    rw [← hR, DecSt.stepSlow]
    step_loop using outer st tbl n hst_ne_tbl htbl_off S.mem hst 13 D n _ _ S.alloc

end MLIR.Firedancer.Lane.fd_r43x6_ge_decode_step_slow
