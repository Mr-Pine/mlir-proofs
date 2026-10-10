module

public import MLIR.Run.Tactic
public import Boringssl.fiat_25519_to_bytes
public import Boringssl.Mlir.fe_tobytes

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_tobytes` stores `f`'s canonical 32 bytes (`fiat_25519_to_bytes.spec`) at `out`; `out` may
alias `f`. `fiat_25519_to_bytes`'s 21 slots are freed again: only the counter moves on. -/
public theorem fe_tobytes.call_eq (out f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hf : s.mem.LimbsFit f) :
    fe_tobytes.call (fe_tobytes.args (.value out) (.value f)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 21⟩,
            mem :=
              s.mem.storeAt out
                (Firedancer.Ref.fiat_25519_to_bytes.spec (s.mem.readLimbs f)) }) := by
  func_init
  block_init
  step_call using fiat_25519_to_bytes.call_eq
  finish_block
  subst hS
  erase_frame

end Proof

end MLIR.Boringssl
