module

public import MLIR.Run.Tactic
public import Boringssl.fe_mul_impl
public import Boringssl.Mlir.fe_mul_tlt

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_mul_tlt` stores `f * g`, carried (`fiat_25519_carry_mul.spec`), at `h`; `h` may alias `f` or
`g`. -/
public theorem fe_mul_tlt.call_eq (h f g : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) (hg : s.mem.LimbsFit g) :
    fe_mul_tlt.call (fe_mul_tlt.args (.value h) (.value f) (.value g)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h
                (Firedancer.Ref.fiat_25519_carry_mul.spec (s.mem.readLimbs f)
                  (s.mem.readLimbs g)) }) := by
  func_init
  block_init
  step_call using fe_mul_impl.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl
