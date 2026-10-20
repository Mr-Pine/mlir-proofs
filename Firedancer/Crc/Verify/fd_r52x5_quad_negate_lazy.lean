module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Common.Wl
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_negate_lazy

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_negate_lazy( _z0 … _z4, x0 … x4 )`: `32 p - X` lane by lane, no carry. The
operands are in the compiled order. -/
def fd_r52x5_quad_negate_lazy.spec (X : Quad5) : Quad5 :=
  let x0 := X.P0
  let x1 := X.P1
  let x2 := X.P2
  let x3 := X.P3
  let x4 := X.P4
  let t0 := wl_sub (wl_bcast 72057594037927328) x0
  let t1 := wl_sub (wl_bcast 72057594037927904) x1
  let t2 := wl_sub (wl_bcast 72057594037927904) x2
  let t3 := wl_sub (wl_bcast 72057594037927904) x3
  let t4 := wl_sub (wl_bcast 72057594037927904) x4
  ⟨t0, t1, t2, t3, t4⟩

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_sub_wl
  zipWith_and_wl zipWith_shl_wl zipWith_lshr_wl zipWith_add_nsw_nuw_reduce
  zipWith_add_nsw_nuw_reduce' zipWith_mul_wl

/-- `fd_r52x5_quad_negate_lazy` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order. -/
public theorem fd_r52x5_quad_negate_lazy.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_negate_lazy.call
        (fd_r52x5_quad_negate_lazy.args (.value _z0) (.value _z1) (.value _z2) (.value _z3)
          (.value _z4) (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4))
        s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_negate_lazy.spec X) }) := by
  func_init
  block_init
  iterate 2 step_pure
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
