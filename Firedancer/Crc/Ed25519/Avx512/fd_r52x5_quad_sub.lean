module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Ed25519.Common.Wl
public import Firedancer.Crc.Ed25519.Common.Reads
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sub

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_sub( _z0 … _z4, x0 … x4, y0 … y4 )`: `X - Y + 16 p` lane by lane, then one carry
pass. The operands are in the compiled order. -/
def fd_r52x5_quad_sub.spec (X Y : Quad5) : Quad5 :=
  let x0 := X.P0
  let x1 := X.P1
  let x2 := X.P2
  let x3 := X.P3
  let x4 := X.P4
  let y0 := Y.P0
  let y1 := Y.P1
  let y2 := Y.P2
  let y3 := Y.P3
  let y4 := Y.P4
  let t0 := wl_sub x0 y0
  let t1 := wl_add t0 (wl_bcast 36028797018963664)
  let t2 := wl_and t1 (wl_bcast 2251799813685247)
  let t3 := wl_sub x4 y4
  let t4 := wl_add t3 (wl_bcast 36028797018963952)
  let t5 := wl_shru t4 51
  let t6 := wl_madd52lo t2 (wl_bcast 19) t5
  let t7 := wl_shru t1 51
  let t8 := wl_sub x1 y1
  let t9 := wl_add t8 (wl_bcast 36028797018963952)
  let t10 := wl_and t9 (wl_bcast 2251799813685247)
  let t11 := wl_add t10 t7
  let t12 := wl_shru t9 51
  let t13 := wl_sub x2 y2
  let t14 := wl_add t13 (wl_bcast 36028797018963952)
  let t15 := wl_and t14 (wl_bcast 2251799813685247)
  let t16 := wl_add t15 t12
  let t17 := wl_shru t14 51
  let t18 := wl_sub x3 y3
  let t19 := wl_add t18 (wl_bcast 36028797018963952)
  let t20 := wl_and t19 (wl_bcast 2251799813685247)
  let t21 := wl_add t20 t17
  let t22 := wl_shru t19 51
  let t23 := wl_and t4 (wl_bcast 2251799813685247)
  let t24 := wl_add t23 t22
  ⟨t6, t11, t16, t21, t24⟩

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_sub_wl
  zipWith_and_wl zipWith_shl_wl zipWith_lshr_wl zipWith_add_nsw_nuw_reduce
  zipWith_add_nsw_nuw_reduce' zipWith_mul_wl

namespace fd_r52x5_quad_sub

/-- `fd_r52x5_quad_sub` from position 5 to 17: its ops there, over the registers live into them. -/
theorem chunk0 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 5 = entry.body.drop 5) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X Y : Quad5}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 36028797018963664#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 36028797018963952#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 51#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 19#64) : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0) (Ty.wrap Y.P1)
          (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get →
        E' ⊨ [rir_reg% hty 1 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 36028797018963952#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 51#64) : Wl),
          rir_reg% hty 9 := ((wl_add (wl_sub X.P4 Y.P4) (Vector.replicate 4 36028797018963952#64)) : Wl),
          rir_reg% hty 11 := ((wl_madd52lo (wl_and (wl_add (wl_sub X.P0 Y.P0) (Vector.replicate 4 36028797018963664#64)) (Vector.replicate 4 2251799813685247#64)) (Vector.replicate 4 19#64) (wl_shru (wl_add (wl_sub X.P4 Y.P4) (Vector.replicate 4 36028797018963952#64)) 51)) : Wl),
          rir_reg% hty 14 := ((wl_add (wl_sub X.P1 Y.P1) (Vector.replicate 4 36028797018963952#64)) : Wl),
          rir_reg% hty 16 := ((wl_add (wl_and (wl_add (wl_sub X.P1 Y.P1) (Vector.replicate 4 36028797018963952#64)) (Vector.replicate 4 2251799813685247#64)) (wl_shru (wl_add (wl_sub X.P0 Y.P0) (Vector.replicate 4 36028797018963664#64)) 51)) : Wl)] →
        (blk.runBodyFrom E' 17 S >>= g) = K) :
    (blk.runBodyFrom E 5 S >>= g) = K := by
  step_pure
  step_pure with t1
  step_pure
  step_pure
  step_pure with t4
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t9
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_sub` from position 17 to 30: its ops there, over the registers live into them. -/
theorem chunk1 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 17 = entry.body.drop 17) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X Y : Quad5} {a9 a11 a14 a16 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hR : E ⊨ [rir_reg% hty 1 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 36028797018963952#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 9 := (a9 : Wl),
      rir_reg% hty 11 := (a11 : Wl), rir_reg% hty 14 := (a14 : Wl), rir_reg% hty 16 := (a16 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0) (Ty.wrap Y.P1)
          (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get →
        E' ⊨ [rir_reg% hty 11 := (a11 : Wl), rir_reg% hty 16 := (a16 : Wl),
          rir_reg% hty 21 := ((wl_add (wl_and (wl_add (wl_sub X.P2 Y.P2) (Vector.replicate 4 36028797018963952#64)) (Vector.replicate 4 2251799813685247#64)) (wl_shru a14 51)) : Wl),
          rir_reg% hty 26 := ((wl_add (wl_and (wl_add (wl_sub X.P3 Y.P3) (Vector.replicate 4 36028797018963952#64)) (Vector.replicate 4 2251799813685247#64)) (wl_shru (wl_add (wl_sub X.P2 Y.P2) (Vector.replicate 4 36028797018963952#64)) 51)) : Wl),
          rir_reg% hty 29 := ((wl_add (wl_and a9 (Vector.replicate 4 2251799813685247#64)) (wl_shru (wl_add (wl_sub X.P3 Y.P3) (Vector.replicate 4 36028797018963952#64)) 51)) : Wl)] →
        (blk.runBodyFrom E' 30 S >>= g) = K) :
    (blk.runBodyFrom E 17 S >>= g) = K := by
  step_pure
  step_pure
  step_pure with t14
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t19
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

end fd_r52x5_quad_sub

/-- `fd_r52x5_quad_sub` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order. -/
public theorem fd_r52x5_quad_sub.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X Y : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_sub.call
        (fd_r52x5_quad_sub.args (.value _z0) (.value _z1) (.value _z2) (.value _z3) (.value _z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
          (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4))
        s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_sub.spec X Y) }) := by
  func_init
  block_init
  iterate 5 step_pure
  refine fd_r52x5_quad_sub.chunk0 (blk := entry) rfl hArgs (by rw [hE]; lemma_reads)
    fun E hArgs hR => ?_
  clear hE
  refine fd_r52x5_quad_sub.chunk1 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  iterate 5 step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
