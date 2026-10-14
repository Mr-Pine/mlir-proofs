module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Mem
public import Firedancer.Lane.Common.Pick
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel
import Mathlib.Data.BitVec
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512
open _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel (Γ)

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel.hty $k)

set_option hygiene false in
/-- `pick_halves mode i k src hF hk ho`: the halves of limb `i` (`k` qwords on, `ho`) of
`PICK( src )` in mode `rows` or `bcast`, `hF` its `RowsFit`/`BcastFit`. -/
local macro "pick_halves " mode:ident i:num k:term:max src:term:max hF:term:max hk:term:max
    ho:term:max : tactic =>
  if mode.getId == `rows then
    `(tactic| step_pattern using
      (runBodyFrom_rowsHalvesRun $k (P := $src) (ho := $ho) (hrow := ($hF).at $i _ $hk)) inline)
  else
    `(tactic| step_pattern using
      (runBodyFrom_bcastHalvesRun $k (P := $src) (ho := $ho) (hb := ($hF).at $i _ $hk)) inline)

set_option hygiene false in
/-- `pick_concat`: a limb's halves, read in the current state, joined. -/
local macro "pick_concat" : tactic =>
  `(tactic| step_pattern using runBodyFrom_concatRun (hm := congrArg GlobalState.mem hS) inline)

set_option hygiene false in
/-- `pick mode src hF hA`: `PICK( src )` in mode `rows` or `bcast` up to limb 4's halves, `hA` the
pointer array's `PtrArray`; with `strides`, computing `2 stride`, `3 stride`, `4 stride` too. -/
local macro "pick " mode:ident src:term:max hF:term:max hA:term:max strides:("strides")? :
    tactic => do
  let rows := mode.getId == `rows
  let limb0 ← if rows then
      `(tactic| step_pattern using
        (runBodyFrom_rowsLimb0Run (P := $src) (hA := $hA)
            (hrow := ($hF).at 0 0 (Nat.zero_mul _).symm))
        inline)
    else
      `(tactic| step_pattern using
        (runBodyFrom_bcastLimb0Run (P := $src) (hA := $hA)
            (hbc := ($hF).at 0 0 (Nat.zero_mul _).symm))
        inline)
  let s2 ← if strides.isSome then `(tactic| step_pure [sh1, sh1']) else `(tactic| skip)
  let s3 ← if strides.isSome then `(tactic| step_pure [m3, m3']) else `(tactic| skip)
  let s4 ← if strides.isSome then `(tactic| step_pure [sh2, sh2']) else `(tactic| skip)
  `(tactic| (
    $limb0
    pick_halves $mode 1 stride.toNat $src $hF (Nat.one_mul _).symm rfl
    pick_concat
    $s2
    pick_halves $mode 2 (2 * stride.toNat) $src $hF rfl n2
    pick_concat
    $s3
    pick_halves $mode 3 (3 * stride.toNat) $src $hF rfl n3
    pick_concat
    $s4
    pick_halves $mode 4 (4 * stride.toNat) $src $hF rfl n4))

set_option hygiene false in
/-- `add_sel_rest mode h`: from `^bb3` in mode `rows` or `bcast` (`h` its `rows ≠ 0` or `rows = 0`):
the products, the other picks, and both `affine` paths into `tail_eq`. -/
local macro "add_sel_rest " mode:ident h:term:max : tactic => do
  let rows := mode.getId == `rows
  let fitM ← if rows then `(hM.rows $h) else `(hM.bcast $h)
  let fitP ← if rows then `(hP.rows $h) else `(hP.bcast $h)
  let fitZ ← if rows then `((hZ hbr).rows $h) else `((hZ hbr).bcast $h)
  `(tactic| (
    -- `^bb3`: `fd_ed25519_lane_mul_loose( &c, &p->t, &q )`
    block_init
    step_pattern using runBodyFrom_concatRun (hm := rfl) inline
    step_pure
    step_load [MemoryState.ofFn_extractVecElem_readAt] with t0
    step_pure
    step_load [MemoryState.ofFn_extractVecElem_readAt] with t1
    step_pure
    step_load [MemoryState.ofFn_extractVecElem_readAt] with t2
    step_pure
    step_load [MemoryState.ofFn_extractVecElem_readAt] with t3
    step_pure
    step_load [MemoryState.ofFn_extractVecElem_readAt] with t4
    step_pattern using runBodyFrom_mulLooseRun_named with c
    step_pure
    step_load [hsm0] inline
    finish_block
    -- `PICK( sm )`
    block_init
    pick $mode M $fitM hsm
    finish_block
    -- `^bb6`: `fd_ed25519_lane_mul_loose( &a, &a, &q )`
    block_init
    step_pattern using runBodyFrom_concatRun (hm := rfl) inline
    step_pattern using runBodyFrom_mulLooseRun_named with a
    step_pure
    step_load [hsp0] inline
    finish_block
    -- `PICK( sp )`
    block_init
    pick $mode P $fitP hsp
    finish_block
    -- `^bb10`: `fd_ed25519_lane_mul_loose( &b, &b, &q )`, `if( affine )`
    block_init
    step_pattern using runBodyFrom_concatRun (hm := rfl) inline
    step_pattern using runBodyFrom_mulLooseRun_named with b
    step_pure
    finish_block
    case isFalse =>
      -- `^bb11`: `d = p->z`
      block_init
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z0
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z1
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z2
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z3
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z4
      finish_block
      -- `fd_ed25519_lane_point_add_fin( r, &a, &b, &c, &d, with_t )`
      refine
        (tail_eq r p sp sm sk sz stride rows affine withT a b c ⟨z0, z1, z2, z3, z4⟩ S E hArgs ?_
          hr ht).trans ?_
      · env_reads
        · rw [hv750]
        · rw [hv1076]
        · rw [hv426]
      · have haff : decide (affine ≠ 0) = true := by simpa using hbr
        simp only [hS, MemoryState.readLanePoint_eq, addQ_compiled, haff, ↓reduceIte]
        clear hE hArgs
        subst_vars
        rfl
    case isTrue =>
      -- `^bb7`: `sz[0]`, `sz + 4`
      have hszA := hsz hbr
      have hsz0 : S.mem.loadPtr sz = .value (Z 0) := by simpa using hszA.2.2 0
      have hszov : ¬sz.offset.uaddOverflow 64#64 := hszA.1
      have hszb : InBounds S.mem sz 512 := hszA.2.1
      block_init
      step_pure
      step_load [hsz0] inline
      finish_block
      -- `PICK( sz )`
      block_init
      pick $mode Z $fitZ hszA
      finish_block
      -- `^bb14`: `fd_ed25519_lane_mul_loose( &d, &p->z, &q )`
      block_init
      step_pattern using runBodyFrom_concatRun (hm := rfl) inline
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z0
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z1
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z2
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z3
      step_pure
      step_load [MemoryState.ofFn_extractVecElem_readAt] with z4
      step_pattern using runBodyFrom_mulLooseRun_named with d
      finish_block
      -- `fd_ed25519_lane_point_add_fin( r, &a, &b, &c, &d, with_t )`
      refine
        (tail_eq r p sp sm sk sz stride rows affine withT a b c d S E hArgs ?_ hr ht).trans ?_
      · env_reads
        · rw [hv750]
        · rw [hv1076]
        · rw [hv426]
      · have haff : decide (affine ≠ 0) = false := by simpa using hbr
        simp only [hS, MemoryState.readLanePoint_eq, addQ_compiled, haff, Bool.false_eq_true,
          ↓reduceIte]
        clear hE hArgs
        subst_vars
        rfl))

/-- The stride's multiples the code computes, `2 s`, `3 s`, `4 s`, do not overflow: `s < 2 ^ 58`. -/
theorem stride_ok (x : BitVec 64) (h : x.toNat < 2 ^ 58) :
    x <<< 1 >>> 1 = x ∧ (x <<< 1).sshiftRight 1 = x ∧ x <<< 2 >>> 2 = x ∧
      (x <<< 2).sshiftRight 2 = x ∧ x.smulOverflow 3#64 = false ∧ x.umulOverflow 3#64 = false ∧
        (x <<< 1).toNat = 2 * x.toNat ∧ (x * 3#64).toNat = 3 * x.toNat ∧
          (x <<< 2).toNat = 4 * x.toNat := by
  have hx : x < 288230376151711744#64 := by
    rw [BitVec.lt_def]; simpa using h
  refine ⟨by bv_decide, by bv_decide, by bv_decide, by bv_decide, by bv_decide, by bv_decide, ?_,
    ?_, ?_⟩
  · rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]; omega
  · rw [BitVec.toNat_mul, Nat.mod_eq_of_lt (by simp; omega)]; simp; omega
  · rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]; omega

/-- `b + 2^11 p - a` as compiled: limb 0 as `(b - a) + 2^11 p`. -/
theorem subBig_11_sel (A B : Fe) :
    subBig B A 11 =
      ⟨wwl_add (wwl_sub B.l0 A.l0) (Vector.replicate 8 4611686018427348992#64),
        wwl_sub (wwl_add B.l1 (Vector.replicate 8 4611686018427385856#64)) A.l1,
        wwl_sub (wwl_add B.l2 (Vector.replicate 8 4611686018427385856#64)) A.l2,
        wwl_sub (wwl_add B.l3 (Vector.replicate 8 4611686018427385856#64)) A.l3,
        wwl_sub (wwl_add B.l4 (Vector.replicate 8 4611686018427385856#64)) A.l4⟩ := by
  simp only [subBig, subOff, bigP_11, Fe.bcast2, wwl_bcast, Fe.zipWith, Fe.mk.injEq, and_true]
  wwl_ring

/-- `a + b` as compiled: `b + a`. -/
theorem addRaw_sel (A B : Fe) :
    addRaw A B = ⟨wwl_add B.l0 A.l0, wwl_add B.l1 A.l1, wwl_add B.l2 A.l2, wwl_add B.l3 A.l3,
      wwl_add B.l4 A.l4⟩ := by
  simp only [addRaw, Fe.zipWith, wwl_add_comm A.l0, wwl_add_comm A.l1, wwl_add_comm A.l2,
    wwl_add_comm A.l3, wwl_add_comm A.l4]

/-- `d + d` as compiled: `d << 1`. -/
theorem addRaw_self_sel (D : Fe) :
    addRaw D D =
      ⟨wwl_shl D.l0 1, wwl_shl D.l1 1, wwl_shl D.l2 1, wwl_shl D.l3 1, wwl_shl D.l4 1⟩ := by
  simp only [addRaw, Fe.zipWith, Fe.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> wwl_ring

/-- `Point.addFin` as compiled: the differences with `2^11 p` as `subBig_11_sel`, `2 d` as a
shift, the sums commuted, the products' operands as the patterns read them. -/
theorem addFin_compiled (A B C D T0 : Fe) (w : Bool) :
    Point.addFin A B C D w T0 =
      let D : Fe := ⟨wwl_shl D.l0 1, wwl_shl D.l1 1, wwl_shl D.l2 1, wwl_shl D.l3 1, wwl_shl D.l4 1⟩
      let E := carry
        ⟨wwl_add (wwl_sub B.l0 A.l0) (Vector.replicate 8 4611686018427348992#64),
          wwl_sub (wwl_add B.l1 (Vector.replicate 8 4611686018427385856#64)) A.l1,
          wwl_sub (wwl_add B.l2 (Vector.replicate 8 4611686018427385856#64)) A.l2,
          wwl_sub (wwl_add B.l3 (Vector.replicate 8 4611686018427385856#64)) A.l3,
          wwl_sub (wwl_add B.l4 (Vector.replicate 8 4611686018427385856#64)) A.l4⟩
      let F := carry
        ⟨wwl_add (wwl_sub D.l0 C.l0) (Vector.replicate 8 4611686018427348992#64),
          wwl_sub (wwl_add D.l1 (Vector.replicate 8 4611686018427385856#64)) C.l1,
          wwl_sub (wwl_add D.l2 (Vector.replicate 8 4611686018427385856#64)) C.l2,
          wwl_sub (wwl_add D.l3 (Vector.replicate 8 4611686018427385856#64)) C.l3,
          wwl_sub (wwl_add D.l4 (Vector.replicate 8 4611686018427385856#64)) C.l4⟩
      let G := carry ⟨wwl_add C.l0 D.l0, wwl_add C.l1 D.l1, wwl_add C.l2 D.l2, wwl_add C.l3 D.l3,
        wwl_add C.l4 D.l4⟩
      let H := carry ⟨wwl_add A.l0 B.l0, wwl_add A.l1 B.l1, wwl_add A.l2 B.l2, wwl_add A.l3 B.l3,
        wwl_add A.l4 B.l4⟩
      ⟨mul ⟨E.l0, E.l1, E.l2, E.l3, E.l4⟩ ⟨F.l0, F.l1, F.l2, F.l3, F.l4⟩,
        mul ⟨G.l0, G.l1, G.l2, G.l3, G.l4⟩ ⟨H.l0, H.l1, H.l2, H.l3, H.l4⟩,
        mul ⟨F.l0, F.l1, F.l2, F.l3, F.l4⟩ ⟨G.l0, G.l1, G.l2, G.l3, G.l4⟩,
        if w then mul ⟨E.l0, E.l1, E.l2, E.l3, E.l4⟩ ⟨H.l0, H.l1, H.l2, H.l3, H.l4⟩ else T0⟩ := by
  simp only [Point.addFin, addRaw_self_sel, subBig_11_sel, addRaw_sel]

/-- `fd_ed25519_lane_sub`'s `4p`, as the compiled constants. -/
theorem fourP_sel : Fe.bcast2 (2 * (2 ^ 52 - 38)) (2 * (2 ^ 52 - 2)) =
    Fe.bcast2 9007199254740916#64 9007199254740988#64 := by
  simp only [Fe.bcast2, Fe.mk.injEq]
  decide

/-- `Point.addQ` as compiled up to `Point.addFin`: `y - x` with `4p`, `y + x` commuted, the
products' operands as the patterns read them. -/
theorem addQ_compiled (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 z0 z1 z2 z3 z4 t0 t1 t2 t3 t4 : Wwl)
    (QP QM QK QZ T0 : Fe) (aff w : Bool) :
    Point.addQ
        ⟨⟨x0, x1, x2, x3, x4⟩, ⟨y0, y1, y2, y3, y4⟩, ⟨z0, z1, z2, z3, z4⟩, ⟨t0, t1, t2, t3, t4⟩⟩
        QP QM QK QZ aff w T0 =
      let A := carry
        ⟨wwl_sub (wwl_add y0 (Vector.replicate 8 9007199254740916#64)) x0,
          wwl_sub (wwl_add y1 (Vector.replicate 8 9007199254740988#64)) x1,
          wwl_sub (wwl_add y2 (Vector.replicate 8 9007199254740988#64)) x2,
          wwl_sub (wwl_add y3 (Vector.replicate 8 9007199254740988#64)) x3,
          wwl_sub (wwl_add y4 (Vector.replicate 8 9007199254740988#64)) x4⟩
      let B := carry ⟨wwl_add x0 y0, wwl_add x1 y1, wwl_add x2 y2, wwl_add x3 y3, wwl_add x4 y4⟩
      Point.addFin (mul ⟨A.l0, A.l1, A.l2, A.l3, A.l4⟩ QM false)
        (mul ⟨B.l0, B.l1, B.l2, B.l3, B.l4⟩ QP false) (mul ⟨t0, t1, t2, t3, t4⟩ QK false)
        (if aff then ⟨z0, z1, z2, z3, z4⟩ else mul ⟨z0, z1, z2, z3, z4⟩ QZ false) w T0 := by
  simp only [Point.addQ, Lane.add, sub, fourP_sel, addRaw_sel]
  simp only [subOff, Fe.bcast2, wwl_bcast, Fe.zipWith]

/-- `runBodyFrom_mulLooseRun` with the product named: `mul A B false` as `C`. -/
theorem runBodyFrom_mulLooseRun_named {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z one k19 k38 a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14
      t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37
      t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 d0 t59 d1 t61
      d2 t63 d3 t65 d4 : Dst Γ V}
    {rest : List (Instr Γ)} {A0 A1 A2 A3 A4 B0 B1 B2 B3 B4 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulLooseRun z one k19 k38 a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10
            t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32
            t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54
            t55 t56 t57 d0 t59 d1 t61 d2 t63 d3 t65 d4 ++
          rest)
    (hR :
      E ⊨ [z := Vector.replicate 8 0#64, one := Vector.replicate 8 1#64, k19 :=
        Vector.replicate 8 19#64, k38 := Vector.replicate 8 38#64, a0 := A0, a1 := A1, a2 := A2,
        a3 := A3, a4 := A4, b0 := B0, b1 := B1, b2 := B2, b3 := B3, b4 := B4])
    (hd :
      [z.i, one.i, k19.i, k38.i, a0.i, a1.i, a2.i, a3.i, a4.i, b0.i, b1.i, b2.i, b3.i, b4.i, t0.i,
          t1.i, t2.i, t3.i, t4.i, t5.i, t6.i, t7.i, t8.i, t9.i, t10.i, t11.i, t12.i, t13.i, t14.i,
          t15.i, t16.i, t17.i, t18.i, t19.i, t20.i, t21.i, t22.i, t23.i, t24.i, t25.i, t26.i, t27.i,
          t28.i, t29.i, t30.i, t31.i, t32.i, t33.i, t34.i, t35.i, t36.i, t37.i, t38.i, t39.i, t40.i,
          t41.i, t42.i, t43.i, t44.i, t45.i, t46.i, t47.i, t48.i, t49.i, t50.i, t51.i, t52.i, t53.i,
          t54.i, t55.i, t56.i, t57.i, d0.i, t59.i, d1.i, t61.i, d2.i, t63.i, d3.i, t65.i,
          d4.i].Nodup)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t6 v_t7 v_t8 v_t9 v_t10 v_t11 v_t12 v_t13 v_t14 v_t15 v_t16
        v_t17 v_t18 v_t19 v_t20 v_t21 v_t22 v_t23 v_t24 v_t25 v_t26 v_t27 v_t28 v_t29 v_t30 v_t31
        v_t32 v_t33 v_t34 v_t35 v_t36 v_t37 v_t38 v_t39 v_t40 v_t41 v_t42 v_t43 v_t44 v_t45 v_t46
        v_t47 v_t48 v_t49 v_t50 v_t51 v_t52 v_t53 v_t54 v_t55 v_t56 v_t57 v_t59 v_t61 v_t63 v_t65 :
        ⟦V⟧, ∀ C : Fe, C = mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false →
        (blk.runBodyFrom
              E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, t6 := v_t6,
                t7 := v_t7, t8 := v_t8, t9 := v_t9, t10 := v_t10, t11 := v_t11, t12 := v_t12, t13 :=
                v_t13, t14 := v_t14, t15 := v_t15, t16 := v_t16, t17 := v_t17, t18 := v_t18, t19 :=
                v_t19, t20 := v_t20, t21 := v_t21, t22 := v_t22, t23 := v_t23, t24 := v_t24, t25 :=
                v_t25, t26 := v_t26, t27 := v_t27, t28 := v_t28, t29 := v_t29, t30 := v_t30, t31 :=
                v_t31, t32 := v_t32, t33 := v_t33, t34 := v_t34, t35 := v_t35, t36 := v_t36, t37 :=
                v_t37, t38 := v_t38, t39 := v_t39, t40 := v_t40, t41 := v_t41, t42 := v_t42, t43 :=
                v_t43, t44 := v_t44, t45 := v_t45, t46 := v_t46, t47 := v_t47, t48 := v_t48, t49 :=
                v_t49, t50 := v_t50, t51 := v_t51, t52 := v_t52, t53 := v_t53, t54 := v_t54, t55 :=
                v_t55, t56 := v_t56, t57 := v_t57, d0 := Ty.wrap C.l0, t59 := v_t59,
                d1 := Ty.wrap C.l1, t61 := v_t61, d2 := Ty.wrap C.l2, t63 := v_t63,
                d3 := Ty.wrap C.l3, t65 := v_t65, d4 := Ty.wrap C.l4]
              (pos + 67) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  refine runBodyFrom_mulLooseRun hbody hR hd ?_
  intros
  apply hK
  rfl

/-- What `^bb15` on reads: the constants and the loose products `a, b, c, d`. -/
abbrev TailEnv (E : ⟪Γ⟫) (A B C D : Fe) : Prop :=
  E ⊨ [%2 := Vector.replicate 8 51#64, %3 := Vector.replicate 8 2251799813685247#64,
    %4 := Vector.replicate 8 19#64, %5 := 0#32, %14 := Vector.replicate 8 0#64,
    %15 := Vector.replicate 8 1#64, %16 := Vector.replicate 8 38#64,
    %17 := Vector.replicate 8 4611686018427348992#64,
    %18 := Vector.replicate 8 4611686018427385856#64,
    %%742 := A.l0, %%744 := A.l1, %%746 := A.l2, %%748 := A.l3, %%750 := A.l4,
    %%1068 := B.l0, %%1070 := B.l1, %%1072 := B.l2, %%1074 := B.l3, %%1076 := B.l4,
    %%418 := C.l0, %%420 := C.l1, %%422 := C.l2, %%424 := C.l3, %%426 := C.l4,
    %%1424 := D.l0, %%1423 := D.l1, %%1422 := D.l2, %%1421 := D.l3, %%1420 := D.l4]

-- 372 instructions, four of them inlined products, in one declaration
set_option maxHeartbeats 4000000 in
/-- From `^bb15`, `fd_ed25519_lane_point_add_fin( r, a, b, c, d, with_t )` stores `Point.addFin` at
`r`: `x`, `z`, `y`, then `t` if `with_t`; else `r`'s `t` stays, and must be known. -/
theorem tail_eq (R p sp sm sk sz : Pointer) (stride : BitVec 64) (rows affine T : BitVec 32)
    (A B C D : Fe) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs :
      E.args =
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel.args (.value R) (.value p)
          (.value sp) (.value sm) (.value sk) (.value sz) (.value stride) (.value rows)
          (.value affine) (.value T)).get)
    (hR : TailEnv E A B C D) (hr : S.mem.LanePointRoom R)
    (ht : T = 0 → S.mem.FeFit (R.add 960#64)) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel.runFrom E 15 S =
      .value (.nil,
        { S with
          mem :=
            S.mem.storeLanePoint R
              (Point.addFin A B C D (T ≠ 0) (S.mem.readFe (R.add 960#64))) }) := by
  obtain ⟨c2, c3, c4, c5, c14, c15, c16, c17, c18, a0, a1, a2, a3, a4, b0, b1, b2, b3, b4, k0, k1,
    k2, k3, k4, d0, d1, d2, d3, d4⟩ := hR
  block_init
  iterate 35 step_pure
  step_pattern using runBodyFrom_carryRun
  step_pattern using runBodyFrom_carryRun
  step_pattern using runBodyFrom_carryRun
  step_pattern using runBodyFrom_carryRun
  -- `fd_ed25519_lane_mul( &r->x, &e, &f )`
  step_pattern using runBodyFrom_mulStoreRun 64 128 192 256 (hov := hr.1)
  clear_stored
  step_pure
  -- `fd_ed25519_lane_mul( &r->z, &f, &g )`
  step_pattern using runBodyFrom_mulStoreRun 704 768 832 896 (hov := hr.1)
  clear_stored
  step_pure
  -- `fd_ed25519_lane_mul( &r->y, &g, &h )`
  step_pattern using runBodyFrom_mulStoreRun 384 448 512 576 (hov := hr.1)
  clear_stored
  -- `if( with_t )`
  step_pure
  finish_block
  case isTrue =>
    block_init
    finish_block
    rw [hS, MemoryState.storeLanePoint_eq_of_t hr.1 (ht hbr) (by simp [Point.addFin, hbr]),
      addFin_compiled]
    subst hv1474 hv1489 hv1504 hv1519
    rfl
  case isFalse =>
    -- `fd_ed25519_lane_mul( &r->t, &e, &h )`
    block_init
    step_pure
    step_pattern using runBodyFrom_mulStoreRun 1024 1088 1152 1216 (hov := hr.1)
    clear_stored
    finish_block
    block_init
    finish_block
    rw [hS, addFin_compiled, MemoryState.storeLanePoint_eq]
    have hT : T ≠ 0 := hbr
    simp only [hT, decide_true, ne_eq, not_false_eq_true, ite_true]
    subst hv1474 hv1489 hv1504 hv1519
    rfl

-- 1874 instructions in 18 blocks, both `rows` modes and both `affine` paths, in one declaration
set_option maxHeartbeats 4000000 in
/-- `fd_ed25519_lane_point_add_sel( r, p, sp, sm, sk, sz, stride, rows, affine, with_t )` stores
`Point.addQ` of the point at `p` and the operands `sp`, `sm`, `sk`, `sz` pick (`sz` unread when
`affine`) at `r`: `x`, `z`, `y`, then `t` if `with_t`; else `r`'s `t` stays, and must be known. All
loads come before the stores, so `r` may alias anything read. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel.call_eq
    (r p sp sm sk sz : Pointer) (P M K Z : Fin 8 → Pointer) (stride : BitVec 64)
    (rows affine withT : BitVec 32) (s : GlobalState) (hwf : s.WF) (hp : s.mem.LanePointFit p)
    (hr : s.mem.LanePointRoom r) (hsp : s.mem.PtrArray sp P) (hsm : s.mem.PtrArray sm M)
    (hsk : s.mem.PtrArray sk K) (hsz : affine = 0 → s.mem.PtrArray sz Z)
    (hP : s.mem.PickFit rows P stride) (hM : s.mem.PickFit rows M stride)
    (hK : s.mem.PickFit rows K stride) (hZ : affine = 0 → s.mem.PickFit rows Z stride)
    (ht : withT = 0 → s.mem.FeFit (r.add 960#64)) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel.args (.value r) (.value p)
          (.value sp) (.value sm) (.value sk) (.value sz) (.value stride) (.value rows)
          (.value affine) (.value withT)) s =
      .value (.nil,
        { s with
          mem :=
            s.mem.storeLanePoint r
              ((s.mem.readLanePoint p).addQ (s.mem.pickFe P stride) (s.mem.pickFe M stride)
                (s.mem.pickFe K stride) (s.mem.pickFe Z stride) (affine ≠ 0) (withT ≠ 0)
                (s.mem.readFe (r.add 960#64))) }) := by
  obtain ⟨sh1, sh1', sh2, sh2', m3, m3', n2, n3, n4⟩ := stride_ok stride hK.stride_lt
  have hsk0 : s.mem.loadPtr sk = .value (K 0) := by simpa using hsk.2.2 0
  have hskov : ¬sk.offset.uaddOverflow 64#64 := hsk.1
  have hskb : InBounds s.mem sk 512 := hsk.2.1
  have hsm0 : s.mem.loadPtr sm = .value (M 0) := by simpa using hsm.2.2 0
  have hsmov : ¬sm.offset.uaddOverflow 64#64 := hsm.1
  have hsmb : InBounds s.mem sm 512 := hsm.2.1
  have hsp0 : s.mem.loadPtr sp = .value (P 0) := by simpa using hsp.2.2 0
  have hspov : ¬sp.offset.uaddOverflow 64#64 := hsp.1
  have hspb : InBounds s.mem sp 512 := hsp.2.1
  func_init
  block_init
  -- the constants
  iterate 19 step_pure
  -- `fd_ed25519_lane_sub( &a, &p->y, &p->x )`, `fd_ed25519_lane_add( &b, &p->y, &p->x )`
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x0
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y1
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x1
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y2
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x2
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y3
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x3
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y4
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x4
  step_pure
  step_pattern using runBodyFrom_carryRun
  iterate 5 step_pure
  step_pattern using runBodyFrom_carryRun
  -- `rows`, and `sk[0]`, `sk + 4`
  step_pure
  step_pure
  step_load [hsk0] inline
  finish_block
  case isFalse =>
    -- `PICK( sk )` by `rows` loads
    have hrows := hbr
    block_init
    pick rows K (hK.rows hrows) hsk strides
    finish_block
    add_sel_rest rows hrows
  case isTrue =>
    -- `PICK( sk )` by broadcasts
    have hrows := hbr
    block_init
    pick bcast K (hK.bcast hrows) hsk strides
    finish_block
    add_sel_rest bcast hrows

end Proof

end MLIR.Firedancer.Lane
