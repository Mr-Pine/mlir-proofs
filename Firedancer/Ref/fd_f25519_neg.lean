module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Limbs
public import Firedancer.Ref.fiat_25519_opp
public import Firedancer.Ref.Mlir.fd_f25519_neg

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `-a`, not carried. -/
def fd_f25519_neg.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  fiat_25519_opp.spec a

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_neg` stores `spec a` at `r` and returns `r`; `r` may alias `a`. -/
public theorem fd_f25519_neg.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsFit r) (ha : s.mem.LimbsFit a) :
    fd_f25519_neg.call (fd_f25519_neg.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeLimbs r (fd_f25519_neg.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  step_call using fiat_25519_opp.call_eq
  finish_block
  simp [hS, fd_f25519_neg.spec]

end Proof

end LeanMLIR.RIR.Firedancer.Ref
