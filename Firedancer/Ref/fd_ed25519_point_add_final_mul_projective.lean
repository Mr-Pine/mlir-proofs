module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_mul3
public import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul_projective

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_ed25519_point_add_final_mul.spec` without `T`, which keeps `T₀`. -/
def fd_ed25519_point_add_final_mul_projective.spec (P : PointLimbs) (T₀ : Fin 5 → BitVec 64) :
    PointLimbs :=
  ⟨fd_f25519_mul.spec P.X P.Y, fd_f25519_mul.spec P.Z P.T, T₀, fd_f25519_mul.spec P.Y P.Z⟩

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_add_final_mul_projective` stores `spec` of the point at `a` at `r`, in another
block, leaving `r`'s `T`, and returns `r`. -/
public theorem fd_ed25519_point_add_final_mul_projective.call_eq (r a : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.PointFit r) (ha : s.mem.PointFit a) (hsep : r.id ≠ a.id) :
    fd_ed25519_point_add_final_mul_projective.call
        (fd_ed25519_point_add_final_mul_projective.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storePoint r
                (fd_ed25519_point_add_final_mul_projective.spec (s.mem.readPoint a)
                  (s.mem.readLimbs (r.add 80#64))) }) := by
  func_init
  have hr₀ : S₀.mem.PointFit r := hS ▸ hr
  block_init
  iterate 5 step_pure
  step_call using fd_f25519_mul3.call_eq
  finish_block
  subst hS
  simp only [fd_ed25519_point_add_final_mul_projective.spec, MemoryState.readPoint,
    MemoryState.storePoint_of_T hr₀]

end Proof

end LeanMLIR.RIR.Firedancer.Ref
