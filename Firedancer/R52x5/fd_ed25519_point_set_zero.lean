module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.R52x5.Mlir.fd_ed25519_point_set_zero

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- 128 zero bytes, as `memset` stores them. -/
private theorem replicate_zero_128 : (0#8).replicate 128 = 0#1024 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_replicate, BitVec.getLsbD_zero, Bool.and_false]

/-- `fd_ed25519_point_set_zero` stores the neutral point at `r` and returns `r`. -/
public theorem fd_ed25519_point_set_zero.call_eq (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Quad5Fit r) :
    fd_ed25519_point_set_zero.call (fd_ed25519_point_set_zero.args (.value r)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeQuad5 r quadZero }) := by
  func_init
  block_init
  iterate 3 step_pure
  step_store
  step_pure
  have hr_1024 := hr.fits_1_4
  step_memset consuming hr_1024
  finish_block
  subst hS
  rw [← MemoryState.storeQuad5_quadZero hr.1, replicate_zero_128]
  rfl

end Proof

end MLIR.Firedancer.R52x5
