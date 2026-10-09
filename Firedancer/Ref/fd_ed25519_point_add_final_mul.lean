module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_mul4
public import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The last step of a point addition, from `(r1, r2, r3, r4)` in `X, Y, Z, T`:
`X = r1 r2`, `Y = r3 r4`, `Z = r2 r3`, `T = r1 r4`. -/
def fd_ed25519_point_add_final_mul.spec (P : PointLimbs) : PointLimbs :=
  ⟨fd_f25519_mul.spec P.X P.Y, fd_f25519_mul.spec P.Z P.T, fd_f25519_mul.spec P.X P.T,
    fd_f25519_mul.spec P.Y P.Z⟩

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_add_final_mul` stores `spec` of the point at `a` at `r`, in another block,
and returns `r`. -/
public theorem fd_ed25519_point_add_final_mul.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointFit r) (ha : s.mem.PointFit a) (hsep : r.id ≠ a.id) :
    fd_ed25519_point_add_final_mul.call (fd_ed25519_point_add_final_mul.args (.value r) (.value a))
        s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storePoint r (fd_ed25519_point_add_final_mul.spec (s.mem.readPoint a)) }) := by
  func_init
  block_init
  iterate 6 step_pure
  step_call using fd_f25519_mul4.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.Ref
