module

public import Firedancer.Lane.fd_r43x6_pow22523
public import Firedancer.Lane.fd_r43x6_ge_decode_fini
public import Firedancer.Lane.fd_r43x6_ge_decode_init
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.Lane.fd_r43x6_ge_decode

open Firedancer.Avx512
open Firedancer.Avx512.fd_r43x6_ge_decode2 (d pSubOne decodePt sqrtM1 quadOf zeroQuad vsub dec)

/-- The lift's registers' context. -/
local notation "Γ" => _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode.Γ

/-- The lift's run from a block. -/
local notation "runG" => _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode.runFrom

/-- Register `k`, its type from the lift's proof (deciding it would unfold `Γ`). -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode.hty $k)

@[expose] public section

/-- The arguments: the out-vectors and the encoding. -/
abbrev argsOf (p03 p14 p25 sp : Pointer) : Vals (Ctx.args Γ) :=
  _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode.args (.value p03) (.value p14) (.value p25)
    (.value sp)

variable {p03 p14 p25 sp : Pointer}

/-- `^bb3`: `*_P25 = %1013`, then return `%1014`. -/
theorem bb3_run (E : ⟪Γ⟫) (S : GlobalState) (hArgs : E.args = (argsOf p03 p14 p25 sp).get)
    (v : Wwl) (r : BitVec 32) (hv : E.read (%%1013) = Ty.wrap v) (hr : E.read (%%1014) = .value r)
    (h25 : Room S.mem p25 512) (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK :
      .value (.cons (.value r) .nil, { S with mem := S.mem.storeAt p25 (BitVec.packLanes v) }) =
        K) :
    runG E 3 S = K := by
  block_init
  step_store consuming h25 hfits_p25
  finish_block only [hr]
  rw [← hK, hS]

/-- `^bb2`: the checks fail; the out-vectors zeroed (`%71`), then `-1` (`%0`). -/
theorem bb2_run (E : ⟪Γ⟫) (S : GlobalState) (hArgs : E.args = (argsOf p03 p14 p25 sp).get)
    (hz : E.read (%71) = Ty.wrap (Vector.replicate 8 0)) (hr : E.read (%0) = .value (-1))
    (h03 : Room S.mem p03 512) (h14 : Room S.mem p14 512) (h25 : Room S.mem p25 512)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK : .value (.cons (.value (-1)) .nil, { S with mem := S.mem.storeQuad3 p03 p14 p25 zeroQuad })
      = K) :
    runG E 2 S = K := by
  block_init
  step_store
  step_store
  finish_block only [hz, hr]
  step_loop using bb3_run
  rw [← hK]
  rfl

/-- `x_mod_2 == x_0` as the compiled select tests it. -/
theorem keep_eq' {α : Type} (a b : BitVec 32) (x y : α) :
    (if BitVec.ofBool (a == b) = 1#1 then x else y) = if a = b then x else y := by
  rw [fd_r43x6_ge_decode_fini.keep_eq]
  by_cases h : a = b
  · rw [ite_eq_left h, ite_eq_left h.symm]
  · rw [ite_eq_right h, ite_eq_right (Ne.symm h)]

end

-- the whole function in one walk: some 160 steps and patterns, over 200000 heartbeats
set_option maxHeartbeats 4000000 in
/-- `fd_r43x6_ge_decode( _P03, _P14, _P25, s )` stores `spec`'s QUAD of the encoding at `sp` at
`p03 p14 p25` (distinct blocks) and returns its code. -/
public theorem call_eq (p03 p14 p25 sp : Pointer) (s : GlobalState) (hwf : s.WF)
    (hs : Fits s.mem sp 256) (hso : ¬sp.offset.uaddOverflow 32#64)
    (h03 : Room s.mem p03 512) (h14 : Room s.mem p14 512) (h25 : Room s.mem p25 512)
    (hids : [p03.id, p14.id, p25.id].Nodup) :
    _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode.call (argsOf p03 p14 p25 sp) s =
      .value
        (.cons (.value (spec (s.mem.readAt sp 256)).1) .nil,
          { s with mem := s.mem.storeQuad3 p03 p14 p25 (spec (s.mem.readAt sp 256)).2 }) := by
  simp only [List.nodup_cons, List.mem_cons, List.mem_nil_iff, or_false, not_or] at hids
  obtain ⟨⟨h0314, h0325⟩, h1425, -⟩ := hids
  generalize hR : spec (s.mem.readAt sp 256) = R
  func_init
  rw [hS] at hR
  have hs₀ : Fits S₀.mem sp 256 := hS ▸ hs
  have hb24 : ¬sp.offset.uaddOverflow 24#64 := BitVec.not_uaddOverflow_of_le hso (by decide)
  block_init
  iterate 79 step_pure
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 1 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 6 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 4 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 negP)
  step_pattern using runBodyFrom_padRunAs (oneLo)
  step_pattern using runBodyFrom_padRunAs (oneHi)
  step_pattern using runBodyFrom_padRunAs (quad19)
  step_pure
  step_load with y3
  step_load with ld
  step_pure with ua
  step_pattern using runBodyFrom_unpackRun with y
  step_pattern using runBodyFrom_sqrRunNW (hX := unpack_lt _) with ysq
  step_pattern using runBodyFrom_subRun with u hu
  step_pattern using runBodyFrom_mulRowsRun d with dysq
  step_pure with v
  step_pattern using runBodyFrom_r43SqrRun with v2
  step_pattern using runBodyFrom_r43SqrRun with v4
  step_pure with bv0
  step_pure with bv1
  step_pure with bv2
  step_pure with bv3
  step_pure with bv4
  step_pure with bv5
  step_pattern using runBodyFrom_mulRowsRun v with v3
  step_pattern using runBodyFrom_mulRun with uv3
  step_pure with buv0
  step_pure with buv1
  step_pure with buv2
  step_pure with buv3
  step_pure with buv4
  step_pure with buv5
  step_pattern using runBodyFrom_mulRowsRun uv3 with uv7
  step_call using fd_r43x6_pow22523.call_eq
  step_pattern using runBodyFrom_mulRowsRun uv3 with x1
  step_pattern using runBodyFrom_r43SqrRun with x2
  step_pattern using runBodyFrom_mulRowsRun v with vx2
  step_pure
  step_pure with t1
  step_pure with t2
  replace ht1 : t1 = lanesBelow 6 (vadd (vsub vx2 (foldSignedPre (vadd ysq pSubOne))) negP) := by
    rw [ht1]; exact fd_r43x6_ge_decode2.sub_add_lanesBelow _ _ _
  subst ht1 ht2
  step_pattern using runBodyFrom_nz2Run with nz
  step_pure
  step_pure
  step_pure
  -- `dec` of the encoding, as the values just computed
  have hy3' : y3 = (S₀.mem.readAt sp 256).extractLsb' 192 64 := by
    rw [hy3, MemoryState.readAt_add_of_readAt hs₀.inBounds hb24 (by decide) rfl]
    rfl
  rw [hld, decLanes_mask, ← hy3'] at hua
  subst hua
  have hA :=
    fd_r43x6_ge_decode2.dec_eq (S₀.mem.readAt sp 256) ysq u dysq v v2 v4 v3 uv3 uv7
      (fd_r43x6_pow22523_2.spec uv7) x1 x2 vx2 (by rw [hysq, hy3']) hu hdysq hv hv2 hv4 hv3 huv3
      huv7 rfl hx1 hx2 hvx2
  clear hysq hu hdysq hv hv2 hv4 hv3 huv3 huv7 hx1 hx2 hvx2
  finish_block
  · -- both nonzero: no root
    rw [hnz] at hbr
    have hfail : ¬(dec (S₀.mem.readAt sp 256)).ok := by
      rw [hA, fd_r43x6_ge_decode2.Dec.ok, fd_r43x6_ge_decode2.ok_iff', not_not]
      exact hbr
    step_loop using bb2_run
    rw [← hR, spec]
    simp only [ite_eq_right hfail]
    exact ⟨by decide, trivial⟩
  · -- a root: `x` or `√-1 x`, of the sign `x_0`
    rw [hnz] at hbr
    have hok : (dec (S₀.mem.readAt sp 256)).ok := by
      rw [hA, fd_r43x6_ge_decode2.Dec.ok, fd_r43x6_ge_decode2.ok_iff']
      exact hbr
    block_init
    step_pure
    step_pure [Avx512.fd_r43x6_ge_decode2.shr63_trunc] with x0
    step_pure
    step_pure
    step_pure
    step_pure with t3
    replace ht3 : t3 = if fd_r43x6_is_nonzero.spec
        (vadd (vsub vx2 (foldSignedPre (vadd ysq pSubOne))) negP) = 0#32 then one else sqrtM1 := by
      rw [ht3, hnz]
      refine (fd_r43x6_ge_decode2.select_not_mask _ _ _ _).trans ?_
      by_cases h : fd_r43x6_is_nonzero.spec
          (vadd (vsub vx2 (foldSignedPre (vadd ysq pSubOne))) negP) = 0#32 <;> simp [h]
    step_pattern using runBodyFrom_mulRun with x'
    step_pattern using runBodyFrom_keep1Run (hX0 := fd_r43x6_ge_decode2.shr63_01 _) with keep
    step_pure
    step_pattern using runBodyFrom_negRun with nx
    step_pure
    step_pure with x''
    replace hx'' : x'' = if fd_r43x6_diagnose.spec x' =
        BitVec.setWidth 32 (BitVec.extractLsb' 192 64 (S₀.mem.readAt sp 256) >>> 63) then x'
        else nx := by
      rw [hx'']
      refine (fd_r43x6_ge_decode2.select_mask _ _ _ _).trans ?_
      rw [hkeep]
      exact keep_eq' _ _ _ _
    step_pattern using runBodyFrom_mulRun with xy
    step_pattern using runBodyFrom_quadPackRunV
    rw [← hx''] at hv997
    subst hv997
    step_pattern using runBodyFrom_quadFoldRunV with a'
    finish_block
    step_loop using bb3_run
    rw [← hR, spec]
    simp only [ite_eq_left hok]
    refine ⟨rfl, ?_⟩
    simp only [MemoryState.storeQuad3, MemoryState.storeVec]
    rw [fd_r43x6_ge_decode_fini.storeAt_thrice h0314 h0325 h1425, hA]
    have hy3'' : S₀.mem.readAt (sp.add 24#64) 64 = (S₀.mem.readAt sp 256).extractLsb' 192 64 := by
      rw [MemoryState.readAt_add_of_readAt hs₀.inBounds hb24 (by decide) rfl]
      rfl
    simp only [quadOf, fd_r43x6_mul, hy3'']
    rfl

end MLIR.Firedancer.Lane.fd_r43x6_ge_decode
