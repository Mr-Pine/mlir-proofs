module

public import Firedancer.Lane.fd_r43x6_ge_decode_step_slow
public import Firedancer.Lane.fd_r43x6_ge_decode2
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_fini
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.Lane.fd_r43x6_ge_decode_fini

open Firedancer.Avx512
open Firedancer.Avx512.fd_r43x6_ge_decode2 (decodePt sqrtM1 quadOf zeroQuad vsub packAt foldAt)

/-- The lift's registers' context. -/
local notation "Γ" => _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_fini.Γ

/-- The lift's run from a block. -/
local notation "runF" => _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_fini.runFrom

/-- Register `k`, its type from the lift's proof (deciding it would unfold `Γ`). -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_fini.hty $k)

@[expose] public section

/-- The arguments: the out-vectors and the state. -/
abbrev argsOf (p03 p14 p25 st : Pointer) : Vals (Ctx.args Γ) :=
  _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_fini.args (.value p03) (.value p14) (.value p25)
    (.value st)

variable {p03 p14 p25 st : Pointer}

/-- Six stores to three distinct blocks, the second three overwriting the first: the second
three. -/
theorem storeAt_thrice {m : MemoryState} {x1 x2 x3 y1 y2 y3 : BitVec 512}
    (h01 : p03.id ≠ p14.id) (h02 : p03.id ≠ p25.id) (h12 : p14.id ≠ p25.id) :
    (((((m.storeAt p03 x1).storeAt p14 x2).storeAt p25 x3).storeAt p03 y1).storeAt p14
          y2).storeAt
        p25 y3 =
      ((m.storeAt p03 y1).storeAt p14 y2).storeAt p25 y3 := by
  rw [fd_r43x6_ge_decode2.storeAt_swap_id (Ne.symm h02),
    fd_r43x6_ge_decode2.storeAt_swap_id (Ne.symm h01), MemoryState.storeAt_storeAt_same,
    fd_r43x6_ge_decode2.storeAt_swap_id (Ne.symm h12), MemoryState.storeAt_storeAt_same,
    MemoryState.storeAt_storeAt_same]

/-- `x_0 == x_mod_2` as the compiled select tests it. -/
theorem keep_eq {α : Type} (a b : BitVec 32) (x y : α) :
    (if BitVec.ofBool (a == b) = 1#1 then x else y) = if b = a then x else y := by
  by_cases h : b = a
  · subst h
    rw [beq_self_eq_true, ite_eq_left (by decide : BitVec.ofBool true = 1#1), ite_eq_left rfl]
  · have h' : (a == b) = false := beq_false_of_ne (Ne.symm h)
    rw [h', ite_eq_right (by decide : ¬BitVec.ofBool false = 1#1), ite_eq_right h]

/-- `^bb3`: `*_P25 = %654`, then return `%655`. -/
theorem bb3_run (E : ⟪Γ⟫) (S : GlobalState) (hArgs : E.args = (argsOf p03 p14 p25 st).get)
    (v : Wwl) (r : BitVec 32) (hv : E.read (%%654) = Ty.wrap v) (hr : E.read (%%655) = .value r)
    (h25 : Room S.mem p25 512) (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK :
      .value (.cons (.value r) .nil, { S with mem := S.mem.storeAt p25 (BitVec.packLanes v) }) =
        K) :
    runF E 3 S = K := by
  block_init
  step_store consuming h25 hfits_p25
  finish_block only [hr]
  rw [← hK, hS]

/-- `^bb2`: the checks fail; the out-vectors zeroed (`%59`), then `-1` (`%8`). -/
theorem bb2_run (E : ⟪Γ⟫) (S : GlobalState) (hArgs : E.args = (argsOf p03 p14 p25 st).get)
    (hz : E.read (%59) = Ty.wrap (Vector.replicate 8 0)) (hr : E.read (%8) = .value (-1))
    (h03 : Room S.mem p03 512) (h14 : Room S.mem p14 512) (h25 : Room S.mem p25 512)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK : .value (.cons (.value (-1)) .nil, { S with mem := S.mem.storeQuad3 p03 p14 p25 zeroQuad })
      = K) :
    runF E 2 S = K := by
  block_init
  step_store
  step_store
  finish_block only [hz, hr]
  step_loop using bb3_run
  rw [← hK]
  rfl

end

-- the whole function in one walk: some 120 steps and patterns, over 200000 heartbeats
set_option maxHeartbeats 4000000 in
/-- `fd_r43x6_ge_decode_fini( _P03, _P14, _P25, st )` finishes the chain of the state `D` at `st`
(`fd_r43x6_ge_decode_step_slow( st, ULONG_MAX )`), then stores `D.fini`'s QUAD at `p03 p14 p25`
(distinct blocks) and returns its code. -/
public theorem call_eq (p03 p14 p25 st : Pointer) (D : DecSt) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_fini.globals)
    (hst : s.mem.DecRoom st) (hD : s.mem.DecHolds st D) (hOk : D.Ok)
    (h03 : Room s.mem p03 512) (h14 : Room s.mem p14 512) (h25 : Room s.mem p25 512)
    (hids : [p03.id, p14.id, p25.id].Nodup) :
    _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_fini.call (argsOf p03 p14 p25 st) s =
      .value
        (.cons (.value D.fini.1) .nil,
          { s with
            mem := (s.mem.storeDec st (D.stepSlow 18446744073709551615#64)).storeQuad3 p03 p14 p25
              D.fini.2 }) := by
  simp only [List.nodup_cons, List.mem_cons, List.mem_nil_iff, or_false, not_or] at hids
  obtain ⟨⟨h0314, h0325⟩, h1425, -⟩ := hids
  generalize hR : D.fini = R
  func_init
  have hst₀ : S₀.mem.DecRoom st := hS ▸ hst
  block_init
  iterate 64 step_pure
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 6 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 4 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 1 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 fd_r43x6_p)
  step_pattern using runBodyFrom_padRunAs (oneLo)
  step_pattern using runBodyFrom_padRunAs (oneHi)
  step_pattern using runBodyFrom_padRunAs (quad19)
  step_call using fd_r43x6_ge_decode_step_slow.call_eq consuming hD hg
  have hD' : S.mem.DecHolds st (D.stepSlow 18446744073709551615#64) := by
    rw [hS]
    exact MemoryState.DecHolds.storeDec hst₀
  obtain
    ⟨⟨fx, rx⟩, -, -, -, -, -, -, ⟨fy, ry⟩, ⟨fu, ru⟩, ⟨fv, rv⟩, ⟨fuv3, ruv3⟩, -, -, ⟨fx0, rx0⟩⟩ :=
    hD'
  have fv6 := fv.mono (show 384 ≤ 512 by decide)
  have rv6 := MemoryState.readAt_of_readAt_le (show 384 ≤ 512 by decide) rv
  have fuv36 := fuv3.mono (show 384 ≤ 512 by decide)
  have ruv36 := MemoryState.readAt_of_readAt_le (show 384 ≤ 512 by decide) ruv3
  clear fv rv fuv3 ruv3
  step_pure
  step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with u
  step_pure
  step_load [load6_eq] with v6
  step_pure
  step_load [load6_eq] with uv36
  step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with x
  step_pattern using runBodyFrom_bcast6Run
  step_pattern using runBodyFrom_mulRowsRun (D.stepSlow 18446744073709551615#64).uv3 with x1
  step_pattern using runBodyFrom_r43SqrRun with x2
  step_pattern using runBodyFrom_bcast6Run
  step_pattern using runBodyFrom_mulRowsRun (D.stepSlow 18446744073709551615#64).v with vx2
  step_pure
  step_pure with t1
  step_pure with t2
  replace ht1 : t1 = lanesBelow 6 (vadd (vsub vx2 u) fd_r43x6_p) := by
    rw [ht1]; exact fd_r43x6_ge_decode2.sub_add_lanesBelow _ _ _
  subst ht1 ht2
  step_pattern using runBodyFrom_nz2Run with nz
  step_pure
  step_pure
  step_pure
  finish_block
  · -- both nonzero: no root
    rw [hnz] at hbr
    have hfail : ¬fd_r43x6_is_nonzero.spec (vadd vx2 u) &&&
        fd_r43x6_is_nonzero.spec (vadd (vsub vx2 u) fd_r43x6_p) = 0#32 := by
      rw [fd_r43x6_ge_decode2.ok_iff', not_not]
      exact hbr
    step_loop using bb2_run
    rw [← hR]
    subst hx hu hx1 hx2 hvx2
    simp only [DecSt.fini, hfail, ite_false]
    exact ⟨by decide, trivial⟩
  · -- a root: `x` or `√-1 x`, of the sign `x_0`
    rw [hnz] at hbr
    have hok : fd_r43x6_is_nonzero.spec (vadd vx2 u) &&&
        fd_r43x6_is_nonzero.spec (vadd (vsub vx2 u) fd_r43x6_p) = 0#32 := by
      rw [fd_r43x6_ge_decode2.ok_iff']
      exact hbr
    block_init
    step_pure
    step_load with x0
    step_pure
    step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with y
    step_pure
    step_pure
    step_pure
    step_pure with t3
    replace ht3 : t3 = if fd_r43x6_is_nonzero.spec (vadd (vsub vx2 u) fd_r43x6_p) != 0 then sqrtM1
        else one := by
      rw [ht3, hnz]
      exact fd_r43x6_ge_decode2.select_not_mask _ _ _ _
    step_pattern using runBodyFrom_mulRun with x'
    step_pattern using runBodyFrom_diag1Run with diag
    step_pure with keep
    step_pure
    step_pattern using runBodyFrom_negRun with nx
    step_pure
    step_pure with x''
    replace hx'' : x'' = if diag = x0 then x' else nx := by
      rw [hx'']
      refine (fd_r43x6_ge_decode2.select_mask _ _ _ _).trans ?_
      rw [hkeep]
      exact keep_eq _ _ _ _
    step_pattern using runBodyFrom_mulRun with xy
    clear hst fx fy fu fx0 fv6 fuv36
    step_pattern using runBodyFrom_quadPackRunV
    rw [← hx''] at hv638
    subst hv638
    step_pattern using runBodyFrom_quadFoldRunV with a'
    finish_block
    step_loop using bb3_run
    rw [← hR]
    subst hx hu hx1 hx2 hvx2
    simp only [DecSt.fini, hok, ite_true]
    refine ⟨rfl, ?_⟩
    simp only [MemoryState.storeQuad3, MemoryState.storeVec]
    rw [storeAt_thrice h0314 h0325 h1425]
    simp only [quadOf, fd_r43x6_mul]
    rfl

end MLIR.Firedancer.Lane.fd_r43x6_ge_decode_fini
