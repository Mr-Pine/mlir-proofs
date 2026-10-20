module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Verify.Mlir.fd_memeq

namespace MLIR.Firedancer.Crc.Verify

/-! ## Specification -/

@[expose] public section

/-- `fd_memeq( a, b )`: `1` when the 32 bytes `x` at `a` and `y` at `b` agree, else `0`. -/
def fd_memeq.spec (x y : BitVec 256) : BitVec 32 :=
  if x = y then 1 else 0

end

/-! ## Proof -/

section Proof

/-- `fd_memeq( a, b )` returns `spec` of the 32 bytes at `a` and `b`. -/
public theorem fd_memeq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : Fits s.mem a 256) (hb : Fits s.mem b 256) :
    fd_memeq.call (fd_memeq.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_memeq.spec (s.mem.readAt a 256) (s.mem.readAt b 256))) .nil, s) := by
  func_init
  block_init
  iterate 2 step_pure
  step_call using Operation.bcmp_eq
  step_pure
  step_pure
  finish_block
  subst hS
  subst_vars
  simp only [spec]
  by_cases h : S.mem.readAt a 256 = S.mem.readAt b 256
  · simp [h, Operation.bcmpResult_self]
  · have hb : (Operation.bcmpResult S.mem.unspec 32 (S.mem.readAt a 256) (S.mem.readAt b 256) ==
        0#32) = false := by
      simpa using fun e => h (Operation.bcmpResult_eq_zero_iff.mp e)
    simp only [hb, h, ↓reduceIte]; rfl

end Proof

end MLIR.Firedancer.Crc.Verify
