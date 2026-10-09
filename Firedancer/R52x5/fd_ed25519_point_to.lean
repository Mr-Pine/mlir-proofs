module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.R52x5.Mlir.fd_ed25519_point_to

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_to` stores the coordinates of the point at `a`, unpacked, at `x, y, z, t`, in
that order. The loads all come before the stores, so the outputs may alias `a` and each other. -/
public theorem fd_ed25519_point_to.call_eq (x y z t a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.Quad5Fit a) (hx : Fits s.mem x 512) (hy : Fits s.mem y 512) (hz : Fits s.mem z 512)
    (ht : Fits s.mem t 512) :
    fd_ed25519_point_to.call
        (fd_ed25519_point_to.args (.value x) (.value y) (.value z) (.value t) (.value a)) s =
      .value
        (.nil,
          { s with
            mem :=
              (((s.mem.storeVec x (s.mem.readQuad5 a).unpack.1).storeVec y
                        (s.mem.readQuad5 a).unpack.2.1).storeVec
                    z (s.mem.readQuad5 a).unpack.2.2.1).storeVec
                t (s.mem.readQuad5 a).unpack.2.2.2 }) := by
  func_init
  block_init
  iterate 20 step_pure
  step_load
  iterate 4 step_pure
  iterate 4 
    step_pure
    step_load
    iterate 4 step_pure
  iterate 4 
    iterate 5 step_pure
    step_store
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.R52x5
