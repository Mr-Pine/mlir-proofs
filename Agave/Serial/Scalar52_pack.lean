module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Scalar
public import Agave.Serial.Mlir.Scalar52_pack
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `s[k] = …`: the address, the store, then the store merged into the bytes before it, so the
state keeps one store at `out`. -/
local macro "store_byte" : tactic =>
  `(tactic|
    ( step_pure
      step_store
      clear_reads
      rw [Agave.storeAt_storeAt_concat (BitVec.not_uaddOverflow_of_le hout_off (by decide))
          (by decide)] at hS))

/-- `Scalar52::pack(self)` stores `spec` of `l`'s limbs at `out` (32 bytes, one 256-bit value). The
loads all come before the stores, so `out` may alias `l`. -/
public theorem Scalar52_pack.call_eq (out l : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hl : s.mem.LimbsFit l) :
    Scalar52_pack.call (Scalar52_pack.args (.value out) (.value l)) s =
      .value
        (.nil, { s with mem := s.mem.storeAt out (Scalar52_pack.spec (s.mem.readLimbs l)) }) := by
  func_init
  block_init
  iterate 12 step_pure
  -- `s[0] … s[5]`, and `self.0[0] >> 48`
  step_load
  iterate 13 step_pure
  -- `s[6] … s[12]`
  step_load
  iterate 16 step_pure
  -- `s[13] … s[18]`, and `self.0[2] >> 48`
  step_load
  iterate 13 step_pure
  -- `s[19] … s[25]`
  step_load
  iterate 16 step_pure
  -- `s[26] … s[31]`
  step_load
  iterate 11 step_pure
  step_store
  clear_reads
  iterate 31 store_byte
  finish_block
  rw [hS]
  refine
    congrArg
      (fun v => PoisonOr.value (Vals.nil, ({ S₀ with mem := S₀.mem.storeAt out v } : GlobalState)))
      ?_
  simp only [Scalar52_pack.spec, Scalar52_pack.bytes, MemoryState.readLimbs]
  generalize S₀.mem.readAt l 64 = x0
  generalize S₀.mem.readAt (l.add 8#64) 64 = x1
  generalize S₀.mem.readAt (l.add 16#64) 64 = x2
  generalize S₀.mem.readAt (l.add 24#64) 64 = x3
  generalize S₀.mem.readAt (l.add 32#64) 64 = x4
  bv_decide

end Proof

end MLIR.Agave.Serial
