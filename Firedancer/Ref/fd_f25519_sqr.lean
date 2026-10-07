module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.fiat_25519_carry_square
public import Firedancer.Ref.Mlir.fd_f25519_sqr

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `a ^ 2`, carried. -/
def fd_f25519_sqr.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  fiat_25519_carry_square.spec a

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_sqr` stores `spec a` at `r` and returns `r`; `r` may alias `a`. -/
public theorem fd_f25519_sqr.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsFit r) (ha : s.mem.LimbsFit a) :
    fd_f25519_sqr.call (fd_f25519_sqr.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeLimbs r (fd_f25519_sqr.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  step_call using fiat_25519_carry_square.call_eq named
  finish_block
  simp [hS, fd_f25519_sqr.spec]

end Proof

end LeanMLIR.RIR.Firedancer.Ref
