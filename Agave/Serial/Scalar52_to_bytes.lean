module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Scalar
public import Agave.Serial.Mlir.Scalar52_to_bytes
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- The store just made merged into the bytes before it, so the state keeps one store at `out`. -/
local macro "merge" : tactic =>
  `(tactic|
    ( clear_reads
      rw [MemoryState.storeAt_storeAt_concat (BitVec.not_uaddOverflow_of_le hout_off (by decide))
          (by decide)] at hS))

/-- `s[k] = (self.0[i] >> j) as u8`: the shift, the address, the byte, its store. -/
local macro "byte" : tactic => `(tactic| (step_pure; step_pure; step_pure; step_store; merge))

/-- `Scalar52::to_bytes(self)` stores `spec` of `l`'s limbs at `out` (32 bytes, one 256-bit value).
Loads and stores interleave, so `out` and `l` are separate objects. -/
public theorem Scalar52_to_bytes.call_eq (out l : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hl : s.mem.LimbsFit l) (hsep : out.id ≠ l.id) :
    Scalar52_to_bytes.call (Scalar52_to_bytes.args (.value out) (.value l)) s =
      .value
        (.nil,
          { s with mem := s.mem.storeAt out (Scalar52_to_bytes.spec (s.mem.readLimbs l)) }) := by
  func_init
  block_init
  iterate 12 step_pure
  -- `s[0] … s[5]`
  step_load
  step_pure
  step_store
  clear_reads
  iterate 5 byte
  -- `s[6] = ((self.0[0] >> 48) | (self.0[1] << 4)) as u8`, `s[7] … s[12]`
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_store
  merge
  iterate 6 byte
  -- `s[13] … s[18]`
  step_pure
  step_load
  iterate 2 step_pure
  step_store
  merge
  iterate 5 byte
  -- `s[19] = ((self.0[2] >> 48) | (self.0[3] << 4)) as u8`, `s[20] … s[25]`
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_store
  merge
  iterate 6 byte
  -- `s[26] … s[31]`
  step_pure
  step_load
  iterate 2 step_pure
  step_store
  merge
  iterate 5 byte
  finish_block
  rw [hS]
  refine
    congrArg
      (fun v => PoisonOr.value (Vals.nil, ({ S₀ with mem := S₀.mem.storeAt out v } : GlobalState)))
      ?_
  simp only [Scalar52_to_bytes.spec, Scalar52_to_bytes.bytes, MemoryState.readLimbs]
  generalize S₀.mem.readAt l 64 = x0
  generalize S₀.mem.readAt (l.add 8#64) 64 = x1
  generalize S₀.mem.readAt (l.add 16#64) 64 = x2
  generalize S₀.mem.readAt (l.add 24#64) 64 = x3
  generalize S₀.mem.readAt (l.add 32#64) 64 = x4
  bv_decide

end Proof

end MLIR.Agave.Serial
