module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_set
public import Firedancer.Ref.Mlir.fd_ed25519_point_from

namespace MLIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_from` stores the point with coordinates `x, y, z, t` at `r`, and returns `r`;
none of them is in `r`'s block. -/
public theorem fd_ed25519_point_from.call_eq (r x y z t : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hx : s.mem.LimbsFit x) (hy : s.mem.LimbsFit y) (hz : s.mem.LimbsFit z)
    (ht : s.mem.LimbsFit t) (hrx : r.id ≠ x.id) (hry : r.id ≠ y.id) (hrz : r.id ≠ z.id)
    (hrt : r.id ≠ t.id) :
    fd_ed25519_point_from.call
        (fd_ed25519_point_from.args (.value r) (.value x) (.value y) (.value z) (.value t)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storePoint r
                ⟨s.mem.readLimbs x, s.mem.readLimbs y, s.mem.readLimbs t,
                  s.mem.readLimbs z⟩ }) := by
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
