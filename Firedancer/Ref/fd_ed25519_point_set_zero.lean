module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_set
public import Firedancer.Ref.Mlir.fd_ed25519_point_set_zero

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The neutral point, `X, Y, T, Z = 0, 1, 0, 1`. -/
def fd_ed25519_point_set_zero.spec : PointLimbs :=
  ⟨fd_f25519_zero.limbs, fd_f25519_one.limbs, fd_f25519_zero.limbs, fd_f25519_one.limbs⟩

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_set_zero` stores the neutral point at `r` and returns `r`; the two globals it
reads count two blocks. -/
public theorem fd_ed25519_point_set_zero.call_eq (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointFit r) :
    fd_ed25519_point_set_zero.call (fd_ed25519_point_set_zero.args (.value r)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storePoint r fd_ed25519_point_set_zero.spec }) := by
  func_init
  block_init
  step_addressof fd_f25519_zero.value_eq with zero
  step_addressof fd_f25519_one.value_eq with one
  have hzero_read := fd_f25519_zero.readLimbs hzero_fits hzero_off hread_zero
  have hone_read := fd_f25519_one.readLimbs hone_fits hone_off hread_one
  have hzero_limbs := MemoryState.LimbsFit.of_fits hzero_fits hzero_off
  have hone_limbs := MemoryState.LimbsFit.of_fits hone_fits hone_off
  clear hread_zero hread_one hzero_fits hone_fits
  step_call using (fd_f25519_set.call_eq (hsep := .inr ?_))
  iterate 3 
    step_pure
    step_call using (fd_f25519_set.call_eq (hsep := .inr ?_))
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref
