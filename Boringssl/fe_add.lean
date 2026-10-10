module

public import MLIR.Run.Tactic
public import Boringssl.fiat_25519_add
public import Boringssl.Mlir.fe_add

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_add` stores `f + g`, not carried (`fiat_25519_add.spec`), at `h`; `h` may alias `f` or `g`.
-/
public theorem fe_add.call_eq (h f g : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) (hg : s.mem.LimbsFit g) :
    fe_add.call (fe_add.args (.value h) (.value f) (.value g)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h
                (Firedancer.Ref.fiat_25519_add.spec (s.mem.readLimbs f)
                  (s.mem.readLimbs g)) }) := by
  func_init
  block_init
  step_call using fiat_25519_add.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl
