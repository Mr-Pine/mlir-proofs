module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Common.Wl
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_reduce

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_reduce( _z0 … _z4, x0 … x4 )`: one carry pass over `X`: each limb's bits above 51
into the next, limb 4's times 19 into limb 0. The operands are in the compiled order. -/
def fd_r52x5_quad_reduce.spec (X : Quad5) : Quad5 :=
  let x0 := X.P0
  let x1 := X.P1
  let x2 := X.P2
  let x3 := X.P3
  let x4 := X.P4
  let t0 := wl_and x0 (wl_bcast 2251799813685247)
  let t1 := wl_shru x4 51
  let t2 := wl_madd52lo t0 (wl_bcast 19) t1
  let t3 := wl_shru x0 51
  let t4 := wl_and x1 (wl_bcast 2251799813685247)
  let t5 := wl_add t4 t3
  let t6 := wl_shru x1 51
  let t7 := wl_and x2 (wl_bcast 2251799813685247)
  let t8 := wl_add t7 t6
  let t9 := wl_shru x2 51
  let t10 := wl_and x3 (wl_bcast 2251799813685247)
  let t11 := wl_add t10 t9
  let t12 := wl_shru x3 51
  let t13 := wl_and x4 (wl_bcast 2251799813685247)
  let t14 := wl_add t13 t12
  ⟨t2, t5, t8, t11, t14⟩

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_sub_wl
  zipWith_and_wl zipWith_shl_wl zipWith_lshr_wl zipWith_add_nsw_nuw_reduce
  zipWith_add_nsw_nuw_reduce' zipWith_mul_wl

/-- `fd_r52x5_quad_reduce` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order. -/
public theorem fd_r52x5_quad_reduce.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_reduce.call
        (fd_r52x5_quad_reduce.args (.value _z0) (.value _z1) (.value _z2) (.value _z3) (.value _z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4))
        s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_reduce.spec X) }) := by
  func_init
  block_init
  iterate 3 step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  iterate 5 step_store
  finish_block
  clear hArgs hE
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Verify
