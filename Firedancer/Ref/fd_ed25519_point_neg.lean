module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_set
public import Firedancer.Ref.fd_f25519_neg
public import Firedancer.Ref.Mlir.fd_ed25519_point_neg

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `-P`: `X` and `T` negated, not carried. -/
def fd_ed25519_point_neg.spec (P : PointLimbs) : PointLimbs :=
  ⟨fd_f25519_neg.spec P.X, P.Y, fd_f25519_neg.spec P.T, P.Z⟩

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_neg` stores `spec` of the point at `a` at `r`, which is `a` itself or in another
block, and returns `r`. -/
public theorem fd_ed25519_point_neg.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointFit r) (ha : s.mem.PointFit a) (hsep : r = a ∨ r.id ≠ a.id) :
    fd_ed25519_point_neg.call (fd_ed25519_point_neg.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem := s.mem.storePoint r (fd_ed25519_point_neg.spec (s.mem.readPoint a)) }) := by
  rcases hsep with rfl | hsep
  · func_init
    -- the stores' chain in `hS` is over `S₀`: reads through it need `S₀`'s point
    have hr₀ : S₀.mem.PointFit r := hS ▸ hr
    block_init
    step_call using fd_f25519_neg.call_eq
    iterate 2 
      step_pure
      step_pure
      step_call using (fd_f25519_set.call_eq (hsep := .inl rfl))
    step_pure
    step_pure
    step_call using fd_f25519_neg.call_eq
    finish_block
    subst hS
    rfl
  · func_init
    block_init
    step_call using fd_f25519_neg.call_eq
    iterate 2 
      step_pure
      step_pure
      step_call using (fd_f25519_set.call_eq (hsep := .inr ?_))
    step_pure
    step_pure
    step_call using fd_f25519_neg.call_eq
    finish_block
    subst hS
    rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref
