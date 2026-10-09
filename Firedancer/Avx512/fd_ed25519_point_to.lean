module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_point_to

namespace MLIR.Firedancer.Avx512

/-! ## Proof -/

section Proof

-- `vpermi2var` stays folded until its index is a literal, for `reduceVpermi2var`
attribute [-mlir_operation] Operation.vpermi2var

/-- `fd_ed25519_point_to` stores the coordinates of the point at `a` at `x, y, z, t`, in that order.
The loads all come before the stores, so the outputs may alias `a` and each other. -/
public theorem fd_ed25519_point_to.call_eq (x y z t a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.QuadFit a) (hx : Fits s.mem x 512) (hy : Fits s.mem y 512)
    (hz : Fits s.mem z 512) (ht : Fits s.mem t 512) :
    fd_ed25519_point_to.call
        (fd_ed25519_point_to.args (.value x) (.value y) (.value z) (.value t) (.value a)) s =
      .value (.nil,
        { s with
          mem :=
            (((s.mem.storeVec x (s.mem.readQuad a).X).storeVec y (s.mem.readQuad a).Y).storeVec z
                (s.mem.readQuad a).Z).storeVec t (s.mem.readQuad a).T }) := by
  func_init
  block_init
  iterate 30 step_pure
  step_load with transparent v03
  step_pure
  step_load with transparent v14
  step_pure
  step_load with transparent v25
  step_pure with c0
  step_pure with c1
  step_pure with c2
  step_pure with c3
  step_pure with x0
  step_store
  step_pure with y0
  step_store
  step_pure with z0
  step_store
  step_pure with t0
  step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Avx512
