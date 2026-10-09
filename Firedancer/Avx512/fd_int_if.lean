module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Mlir.fd_int_if

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_int_if(c, -1, f)`: `-1` when `c` is set, else `f`. The compiler propagated the `-1` of the
only call (in `fd_r43x6_diagnose`). -/
abbrev fd_int_if.spec (c f : BitVec 32) : BitVec 32 :=
  if c = 0#32 then f else -1#32

end

/-! ## Proof -/

section Proof

/-- `fd_int_if` returns `spec c f` and leaves the state as it is. -/
public theorem fd_int_if.call_eq (c f : BitVec 32) (s : GlobalState) (hwf : s.WF) :
    fd_int_if.call (fd_int_if.args (.value c) (.value f)) s =
      .value (.cons (.value (fd_int_if.spec c f)) .nil, s) := by
  func_init
  block_init
  iterate 4 step_pure
  finish_block
  subst_vars
  simp only [fd_int_if.spec]
  by_cases h : c = 0#32 <;> simp [h, beq_eq_false_iff_ne.mpr]

end Proof

end MLIR.Firedancer.Avx512
