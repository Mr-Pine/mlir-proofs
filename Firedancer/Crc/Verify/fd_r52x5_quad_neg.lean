module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Common.Wl
public import Firedancer.Crc.Verify.Reads
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_neg( _z0 … _z4, x0 … x4 )`: `16 p - X` lane by lane, then one carry pass. The
operands are in the compiled order. -/
def fd_r52x5_quad_neg.spec (X : Quad5) : Quad5 :=
  let x0 := X.P0
  let x1 := X.P1
  let x2 := X.P2
  let x3 := X.P3
  let x4 := X.P4
  let t0 := wl_sub (wl_bcast 36028797018963664) x0
  let t1 := wl_and t0 (wl_bcast 2251799813685247)
  let t2 := wl_sub (wl_bcast 36028797018963952) x4
  let t3 := wl_shru t2 51
  let t4 := wl_madd52lo t1 (wl_bcast 19) t3
  let t5 := wl_shru t0 51
  let t6 := wl_sub (wl_bcast 36028797018963952) x1
  let t7 := wl_and t6 (wl_bcast 2251799813685247)
  let t8 := wl_add t7 t5
  let t9 := wl_shru t6 51
  let t10 := wl_sub (wl_bcast 36028797018963952) x2
  let t11 := wl_and t10 (wl_bcast 2251799813685247)
  let t12 := wl_add t11 t9
  let t13 := wl_shru t10 51
  let t14 := wl_sub (wl_bcast 36028797018963952) x3
  let t15 := wl_and t14 (wl_bcast 2251799813685247)
  let t16 := wl_add t15 t13
  let t17 := wl_shru t14 51
  let t18 := wl_and t2 (wl_bcast 2251799813685247)
  let t19 := wl_add t18 t17
  ⟨t4, t8, t12, t16, t19⟩

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_sub_wl
  zipWith_and_wl zipWith_shl_wl zipWith_lshr_wl zipWith_add_nsw_nuw_reduce
  zipWith_add_nsw_nuw_reduce' zipWith_mul_wl

namespace fd_r52x5_quad_neg

/-- `fd_r52x5_quad_neg` from position 5 to 14: its ops there, over the registers live into them. -/
theorem chunk0 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 5 = entry.body.drop 5) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X : Quad5}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 36028797018963664#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 36028797018963952#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 51#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 19#64) : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get →
        E' ⊨ [rir_reg% hty 1 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 36028797018963952#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 51#64) : Wl),
          rir_reg% hty 7 := ((wl_sub (Vector.replicate 4 36028797018963952#64) X.P4) : Wl),
          rir_reg% hty 9 := ((wl_madd52lo (wl_and (wl_sub (Vector.replicate 4 36028797018963664#64) X.P0) (Vector.replicate 4 2251799813685247#64)) (Vector.replicate 4 19#64) (wl_shru (wl_sub (Vector.replicate 4 36028797018963952#64) X.P4) 51)) : Wl),
          rir_reg% hty 11 := ((wl_sub (Vector.replicate 4 36028797018963952#64) X.P1) : Wl),
          rir_reg% hty 13 := ((wl_add (wl_and (wl_sub (Vector.replicate 4 36028797018963952#64) X.P1) (Vector.replicate 4 2251799813685247#64)) (wl_shru (wl_sub (Vector.replicate 4 36028797018963664#64) X.P0) 51)) : Wl)] →
        (blk.runBodyFrom E' 14 S >>= g) = K) :
    (blk.runBodyFrom E 5 S >>= g) = K := by
  step_pure with t0
  step_pure
  step_pure with t2
  step_pure
  step_pure
  step_pure
  step_pure with t6
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_neg` from position 14 to 25: its ops there, over the registers live into them. -/
theorem chunk1 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 14 = entry.body.drop 14) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X : Quad5} {a7 a9 a11 a13 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hR : E ⊨ [rir_reg% hty 1 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 36028797018963952#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 7 := (a7 : Wl),
      rir_reg% hty 9 := (a9 : Wl), rir_reg% hty 11 := (a11 : Wl), rir_reg% hty 13 := (a13 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get →
        E' ⊨ [rir_reg% hty 9 := (a9 : Wl), rir_reg% hty 13 := (a13 : Wl),
          rir_reg% hty 17 := ((wl_add (wl_and (wl_sub (Vector.replicate 4 36028797018963952#64) X.P2) (Vector.replicate 4 2251799813685247#64)) (wl_shru a11 51)) : Wl),
          rir_reg% hty 21 := ((wl_add (wl_and (wl_sub (Vector.replicate 4 36028797018963952#64) X.P3) (Vector.replicate 4 2251799813685247#64)) (wl_shru (wl_sub (Vector.replicate 4 36028797018963952#64) X.P2) 51)) : Wl),
          rir_reg% hty 24 := ((wl_add (wl_and a7 (Vector.replicate 4 2251799813685247#64)) (wl_shru (wl_sub (Vector.replicate 4 36028797018963952#64) X.P3) 51)) : Wl)] →
        (blk.runBodyFrom E' 25 S >>= g) = K) :
    (blk.runBodyFrom E 14 S >>= g) = K := by
  step_pure
  step_pure with t10
  step_pure
  step_pure
  step_pure
  step_pure with t14
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

end fd_r52x5_quad_neg

/-- `fd_r52x5_quad_neg` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order. -/
public theorem fd_r52x5_quad_neg.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_neg.call
        (fd_r52x5_quad_neg.args (.value _z0) (.value _z1) (.value _z2) (.value _z3) (.value _z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4))
        s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_neg.spec X) }) := by
  func_init
  block_init
  iterate 5 step_pure
  refine fd_r52x5_quad_neg.chunk0 (blk := entry) rfl hArgs (by rw [hE]; lemma_reads)
    fun E hArgs hR => ?_
  clear hE
  refine fd_r52x5_quad_neg.chunk1 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  iterate 5 step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Verify
