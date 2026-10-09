module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_set
public import Firedancer.Ref.Mlir.fd_ed25519_point_to

namespace MLIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_to` copies the coordinates of the point at `p` out to `x, y, z, t`, none of
which is in `p`'s block. -/
public theorem fd_ed25519_point_to.call_eq (x y z t p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : s.mem.PointFit p) (hx : s.mem.LimbsFit x) (hy : s.mem.LimbsFit y) (hz : s.mem.LimbsFit z)
    (ht : s.mem.LimbsFit t) (hxp : x.id ≠ p.id) (hyp : y.id ≠ p.id) (hzp : z.id ≠ p.id)
    (htp : t.id ≠ p.id) :
    fd_ed25519_point_to.call
        (fd_ed25519_point_to.args (.value x) (.value y) (.value z) (.value t) (.value p)) s =
      .value
        (.nil,
          { s with
            mem :=
              let P := s.mem.readPoint p
              (((s.mem.storeLimbs x P.X).storeLimbs y P.Y).storeLimbs z P.Z).storeLimbs t
                P.T }) := by
  func_init
  block_init
  step_call using (fd_f25519_set.call_eq (hsep := .inr ?_))
  iterate 3 
    step_pure
    step_call using (fd_f25519_set.call_eq (hsep := .inr ?_))
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.Ref
