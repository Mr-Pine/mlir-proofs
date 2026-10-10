module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.fiat_25519_carry_mul
public import Firedancer.Ref.Mlir.fd_f25519_mul

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `a * b`, carried. -/
def fd_f25519_mul.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  fiat_25519_carry_mul.spec a b

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_mul` stores `spec a b` at `r` and returns `r`; `r` may alias `a` or `b`. -/
public theorem fd_f25519_mul.call_eq (r a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsRoom r) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    fd_f25519_mul.call (fd_f25519_mul.args (.value r) (.value a) (.value b)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeLimbs r
                (fd_f25519_mul.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  block_init
  step_call using fiat_25519_carry_mul.call_eq named
  finish_block
  simp [hS, fd_f25519_mul.spec]

end Proof

end MLIR.Firedancer.Ref
