module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_point_set_zero

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- The neutral point `(0, 1, 1, 0)`, reduced: `wwl(0,1,1,0, 0,0,0,0)`, then zeros. -/
def fd_ed25519_point_set_zero.spec : Quad :=
  ⟨#v[0, 1, 1, 0, 0, 0, 0, 0], Vector.replicate 8 0, Vector.replicate 8 0⟩

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_set_zero` stores the neutral point at `r` and returns `r`. -/
public theorem fd_ed25519_point_set_zero.call_eq (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadFit r) :
    fd_ed25519_point_set_zero.call (fd_ed25519_point_set_zero.args (.value r)) s =
      .value (.cons (.value r) .nil,
        { s with mem := s.mem.storeQuad r fd_ed25519_point_set_zero.spec }) := by
  func_init
  block_init
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  have hr_1024 := hr.fits_14_25
  step_memset consuming hr_1024
  finish_block
  subst hS
  rw [MemoryState.storeAt_zero_14_25 hr.1]
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
