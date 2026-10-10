module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fiat_25519_carry_square
public import Boringssl.Mlir.fe_sq_tt

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_sq_tt` stores `f ^ 2`, carried (`fiat_25519_carry_square.spec`), at `h`; `h` may alias `f`.
-/
public theorem fe_sq_tt.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) :
    fe_sq_tt.call (fe_sq_tt.args (.value h) (.value f)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h
                (Firedancer.Ref.fiat_25519_carry_square.spec (s.mem.readLimbs f)) }) := by
  func_init
  block_init
  step_call using Firedancer.Ref.fiat_25519_carry_square.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl
