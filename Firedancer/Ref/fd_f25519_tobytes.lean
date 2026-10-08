module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Limbs
public import Firedancer.Ref.fiat_25519_to_bytes
public import Firedancer.Ref.Mlir.fd_f25519_tobytes

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `a`'s canonical 32 bytes, byte `k` at bits `8k …`. -/
def fd_f25519_tobytes.spec (a : Fin 5 → BitVec 64) : BitVec 256 :=
  fiat_25519_to_bytes.spec a

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_tobytes` stores `spec a` at `out` (32 bytes) and returns `out`; `out` may alias
`a`. `fiat_25519_to_bytes`'s 21 slots are freed again: only the counter moves on. -/
public theorem fd_f25519_tobytes.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (ha : s.mem.LimbsFit a) :
    fd_f25519_tobytes.call (fd_f25519_tobytes.args (.value out) (.value a)) s =
      .value
        (.cons (.value out) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 21⟩,
            mem := s.mem.storeAt out (fd_f25519_tobytes.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  step_call using fiat_25519_to_bytes.call_eq
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref
