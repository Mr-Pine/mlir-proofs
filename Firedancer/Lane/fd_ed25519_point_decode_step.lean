module

public import Firedancer.Lane.fd_r43x6_ge_decode_step_slow
public import Firedancer.Lane.Mlir.fd_ed25519_point_decode_step
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.Lane.fd_ed25519_point_decode_step

open Firedancer.Avx512
open fd_r43x6_ge_decode_step_slow (add2_eq add2_last add2_ne sqrN_succ' and_m2_nat and_one_toNat
  odd_trunc)

/-- The lift's registers' context. -/
local notation "Γ" => _root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_step.Γ

/-- The lift's run from a block. -/
local notation "runG" => _root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_step.runFrom

@[expose] public section

/-- The arguments. -/
abbrev argsOf (st : Pointer) (n : BitVec 64) : Vals (Ctx.args Γ) :=
  _root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_step.args (.value st) (.value n)

/-- The entry block's registers the squarings read: the constants, `rem`'s pointer and `rem`. -/
abbrev Regs (st : Pointer) (r : BitVec 64) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1 := .value 2#64, %2 := Ty.wrap foldK, %3 := Ty.wrap foldShifts, %4 := Ty.wrap foldMask,
    %5 := Ty.wrap (Vector.replicate 8 24), %6 := Ty.wrap (Vector.replicate 8 7),
    %7 := Ty.wrap #v[-1, -1, -1, -1, -1, -1, 0, 0], %15 := .value 0#64, %16 := .value 1#64,
    %17 := .value 18446744073709551614#64, %19 := Ty.wrap sqrDbl0, %20 := Ty.wrap sqrDbl2,
    %21 := Ty.wrap sqrDbl4, %22 := Ty.wrap (Vector.replicate 8 0),
    %23 := Ty.wrap (Vector.replicate 8 9), %24 := Ty.wrap sqrMaskN1, %25 := Ty.wrap sqrMaskN2,
    %37 := lanesBelow 6 sqrMask1, %45 := lanesBelow 6 sqrMask2, %53 := lanesBelow 5 sqrMask1,
    %61 := lanesBelow 5 sqrMask2, %69 := lanesFrom 7 wwl_zero, %77 := lanesBelow 5 wwl_zero,
    %78 := .value (st.add 712#64), %79 := .value r]

variable (st : Pointer) (n r : BitVec 64) (K : PoisonOr (Vals [] × GlobalState))

/-- `^bb6`: the squared `x` and `rem - n` stored; return. -/
theorem bb6 (x : Wwl) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = (argsOf st n).get) (hR : Regs st r E)
    (hX : E ⊨ [%136 := x]) (hx : Room S.mem st 512)
    (hr : Room S.mem (st.add 712#64) 64)
    (hK :
      .value (.nil,
          { S with mem := (S.mem.storeAt st (BitVec.packLanes x)).storeAt (st.add 712#64) (r - n) })
        = K) :
    runG E 6 S = K := by
  dsimp only [Regs] at hR
  casesm* _ ∧ _
  block_init
  step_store
  step_pure
  step_store
  finish_block
  block_init
  finish_block
  rw [← hK, hS]

/-- `^bb5`: one squaring of `x`, `n` odd; on to `^bb6`. -/
theorem bb5 (hk : n.setWidth 1 = 1#1) (x : Wwl) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = (argsOf st n).get) (hR : Regs st r E) (hX : E ⊨ [%87 := x])
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (argsOf st n).get → Regs st r E' →
      E' ⊨ [%136 := fd_r43x6_sqr x] → runG E' 6 S = K) :
    runG E 5 S = K := by
  dsimp only [Regs] at hR
  casesm* _ ∧ _
  block_init
  step_pure [hk]
  step_assume
  step_pattern using runBodyFrom_r43SqrRun with x1
  finish_block
  step_loop using hK

/-- `^bb7`: `q + 1` more pairs of squarings of `x`, the counter `i` up to the even count `c`; then
`^bb4` with the result in `%233`. -/
theorem loop7 (S : GlobalState) (c : BitVec 64) :
    ∀ q (x : Wwl) (i : Nat) (E : ⟪Γ⟫), E.args = (argsOf st n).get → Regs st r E →
      E ⊨ [%83 := .value (n &&& 1#64), %85 := .value c, %138 := x, %139 :=
        .value (BitVec.ofNat 64 i)] →
      i + 2 * (q + 1) = c.toNat →
      (∀ E' : ⟪Γ⟫, E'.args = (argsOf st n).get → Regs st r E' →
        E' ⊨ [%83 := .value (n &&& 1#64), %233 := sqrPairs q x] → runG E' 4 S = K) →
      runG E 7 S = K := by
  intro q
  induction q with
  | zero =>
    intro x i E hA hR hX hc hK
    dsimp only [Regs] at hR
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
    dsimp only [Regs] at hR
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

/-- `^bb1` to `^bb6`: `n` squarings of `x`, read from the state: two at a time, then one if `n` is
odd. -/
theorem sqrPhase (x : Wwl) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = (argsOf st n).get)
    (hR : Regs st r E) (hfx : Fits S.mem st 512) (hrx : S.mem.readAt st 512 = BitVec.packLanes x)
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (argsOf st n).get → Regs st r E' →
        E' ⊨ [%136 := Avx512.fd_r43x6_repsqr_mul2.sqrN n.toNat x] → runG E' 6 S = K) :
    runG E 1 S = K := by
  dsimp only [Regs] at hR
  casesm* _ ∧ _
  block_init
  step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with x'
  step_pure
  finish_block
  · -- `n = 0`: no squarings
    step_loop using hK
    rfl
  · have hn0 := hbr
    block_init
    step_pure
    step_pure
    finish_block
    · -- `n = 1`: one squaring
      step_loop using bb5 st n r K (by rw [hbr]; decide) x
      intro hR' hX'
      rw [hS]
      refine hK _ hArgs₀ hR' ?_
      rw [hbr]
      exact hX'
    · -- the pairs, then one more if `n` is odd
      block_init
      step_pure
      finish_block
      have h2 : 2 ≤ n.toNat := by
        have : n.toNat ≠ 0 := fun h => hn0 (BitVec.eq_of_toNat_eq h)
        have : n.toNat ≠ 1 := fun h => hbr (BitVec.eq_of_toNat_eq h)
        omega
      step_loop using loop7 st n r K S (n &&& 18446744073709551614#64) (n.toNat / 2 - 1) x 0
      · rw [and_m2_nat]
        omega
      intro hR' hX'
      block_init
      step_pure
      finish_block
      · -- even
        step_loop using hK
        rw [sqrPairs_eq]
        congr 2
        have := and_one_toNat n
        rw [hbr] at this
        simp at this
        omega
      · -- odd
        step_loop using bb5 st n r K (odd_trunc hbr) (sqrPairs _ x)
        intro hR'' hX''
        rw [hS]
        refine hK _ hArgs₀ hR'' ?_
        rw [hX'', sqrPairs_eq, ← sqrN_succ']
        congr 2
        have := and_one_toNat n
        rw [BitVec.toNat_eq] at hbr
        simp at hbr this
        omega

end

/-- `fd_ed25519_point_decode_step( st, n )` stores `D.step n` over the state `D` at `st`, the named
multipliers its stages need set. -/
public theorem call_eq (st : Pointer) (n : BitVec 64) (D : DecSt) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_step.globals)
    (hst : s.mem.DecRoom st) (hD : s.mem.DecHolds st D) (hOk : D.Ok) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_step.call (argsOf st n) s =
      .value (.nil, { s with mem := s.mem.storeDec st (D.step n) }) := by
  have hself := MemoryState.storeDec_self hD
  have hx := decRoom_room hst 0#64 512
  have hr := decRoom_room hst 712#64 64
  rw [Pointer.add_zero] at hx
  have hov := hst.1
  obtain ⟨⟨fx, rx⟩, -, -, -, -, -, -, -, -, -, -, ⟨fs, rs⟩, ⟨fr, rr⟩, -⟩ := id hD
  generalize hR : D.step n = R
  func_init
  block_init
  iterate 30 step_pure
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pure
  step_load
  step_pure
  finish_block
  · -- `rem < n`: the slow step, unless the chain is done
    have hlt := hbr
    block_init
    step_pure
    step_load
    step_pure
    finish_block
    · have hs : D.stage < 12 := BitVec.ult_iff_lt.mp hbr
      block_init
      step_call using fd_r43x6_ge_decode_step_slow.call_eq consuming hD hg
      finish_block
      block_init
      finish_block
      rw [hS, ← hR, DecSt.step, ite_eq_right (not_not.2 hlt), ite_eq_left hs]
    · have hs : ¬D.stage < 12 := fun h => hbr (BitVec.ult_iff_lt.mpr h)
      block_init
      finish_block
      subst hS
      rw [← hR, DecSt.step, ite_eq_right (not_not.2 hlt), ite_eq_right hs, hself]
  · -- `n ≤ rem`: `n` squarings
    step_loop using sqrPhase st n D.rem _ D.x
    intro hR' hX'
    refine bb6 st n D.rem _ _ _ _ hArgs₀ hR' hX' hx hr ?_
    rw [← hR, DecSt.step, ite_eq_left hbr, ← hself, MemoryState.storeDec_storeAt_x hov,
      MemoryState.storeDec_storeAt_rem hov]
    subst_vars
    rfl

end MLIR.Firedancer.Lane.fd_ed25519_point_decode_step
