module

public import MLIR.Run.Tactic
public import Agave.Common.Scalar
public import Agave.Serial.Scalar52_to_bytes
public import Agave.Serial.Mlir.Scalar52_pack

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

/-- `Scalar52::pack(self)` stores `spec` of `l`'s limbs at `out` (32 bytes, one 256-bit value), by
`to_bytes`; `out` and `l` are separate objects. -/
public theorem Scalar52_pack.call_eq (out l : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hl : s.mem.LimbsFit l) (hsep : out.id ≠ l.id) :
    Scalar52_pack.call (Scalar52_pack.args (.value out) (.value l)) s =
      .value
        (.nil, { s with mem := s.mem.storeAt out (Scalar52_pack.spec (s.mem.readLimbs l)) }) := by
  func_init
  block_init
  step_call using Scalar52_to_bytes.call_eq
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Agave.Serial
