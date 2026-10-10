module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fiat_25519_carry_mul
public import Boringssl.Mlir.fe_mul_impl

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_mul_impl` stores `in1 * in2`, carried (`fiat_25519_carry_mul.spec`), at `out`; `out` may
alias `in1` or `in2`. -/
public theorem fe_mul_impl.call_eq (out in1 in2 : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hin1 : s.mem.LimbsFit in1) (hin2 : s.mem.LimbsFit in2) :
    fe_mul_impl.call (fe_mul_impl.args (.value out) (.value in1) (.value in2)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (Firedancer.Ref.fiat_25519_carry_mul.spec (s.mem.readLimbs in1)
                  (s.mem.readLimbs in2)) }) := by
  func_init
  block_init
  step_call using Firedancer.Ref.fiat_25519_carry_mul.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl
