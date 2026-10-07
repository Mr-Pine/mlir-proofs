module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.fiat_25519_add
public import Firedancer.Ref.Mlir.fd_f25519_add_nr

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `a + b`, not carried. -/
def fd_f25519_add_nr.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  fiat_25519_add.spec a b

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_add_nr` stores `spec a b` at `r` and returns `r`; `r` may alias `a` or `b`. -/
public theorem fd_f25519_add_nr.call_eq (r a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsFit r) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    fd_f25519_add_nr.call (fd_f25519_add_nr.args (.value r) (.value a) (.value b)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeLimbs r
                (fd_f25519_add_nr.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  block_init
  step_call using fiat_25519_add.call_eq
  finish_block
  simp [hS, fd_f25519_add_nr.spec]

end Proof

end LeanMLIR.RIR.Firedancer.Ref
