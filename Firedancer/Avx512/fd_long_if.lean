module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Mlir.fd_long_if

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_long_if(c, 19L, 0L)`: `19` when `c` is set, else `0`. The compiler propagated the
constants of the only call (in `fd_r43x6_mod_nearly_reduced_limbs`). -/
abbrev fd_long_if.spec (c : BitVec 32) : BitVec 64 :=
  if c = 0#32 then 0#64 else 19#64

end

/-! ## Proof -/

section Proof

/-- `fd_long_if` returns `spec c` and leaves the state as it is. -/
public theorem fd_long_if.call_eq (c : BitVec 32) (s : GlobalState) (hwf : s.WF) :
    fd_long_if.call (fd_long_if.args (.value c)) s =
      .value (.cons (.value (fd_long_if.spec c)) .nil, s) := by
  func_init
  block_init
  iterate 5 step_pure
  finish_block
  subst_vars
  simp only [fd_long_if.spec]
  by_cases h : c = 0#32 <;> simp [h, beq_eq_false_iff_ne.mpr]

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
