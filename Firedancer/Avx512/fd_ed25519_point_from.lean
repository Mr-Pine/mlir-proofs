module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_point_from

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `(x : y : z : t)` packed into a point. -/
def fd_ed25519_point_from.spec (x y z t : Wwl) : Quad :=
  Quad.pack x y z t

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_from` stores the point of the field elements at `x, y, z, t` at `r` and
returns `r`. The loads all come before the stores, so `r` may alias the inputs. -/
public theorem fd_ed25519_point_from.call_eq (r x y z t : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (hx : Fits s.mem x 512) (hy : Fits s.mem y 512) (hz : Fits s.mem z 512)
    (ht : Fits s.mem t 512) :
    fd_ed25519_point_from.call
        (fd_ed25519_point_from.args (.value r) (.value x) (.value y) (.value z) (.value t)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeQuad r
                (fd_ed25519_point_from.spec (s.mem.readVec x) (s.mem.readVec y) (s.mem.readVec z)
                  (s.mem.readVec t)) }) := by
  func_init
  block_init
  step_load with transparent vx
  step_load with transparent vy
  step_load with transparent vz
  step_load with transparent vt
  iterate 9 step_pure
  step_store
  iterate 2
    step_pure
    step_pure
    step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Avx512
