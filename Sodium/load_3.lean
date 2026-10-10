module

public import MLIR.Run.Tactic
public import Sodium.Mlir.load_3
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- The compiled `in[0] | in[1] << 8 | in[2] << 16`: a 16-bit load and a byte above it, whose
`shl nuw nsw` and `or disjoint` hold. -/
theorem load_3.bits (x : BitVec 24) :
    (x.extractLsb' 16 8).setWidth 64 <<< 16 >>> 16 = (x.extractLsb' 16 8).setWidth 64 ∧
      ((x.extractLsb' 16 8).setWidth 64 <<< 16).sshiftRight 16 = (x.extractLsb' 16 8).setWidth 64 ∧
      ((x.extractLsb' 16 8).setWidth 64 <<< 16 &&& (x.setWidth 16).setWidth 64 = 0#64) ∧
      (x.extractLsb' 16 8).setWidth 64 <<< 16 ||| (x.setWidth 16).setWidth 64 = x.setWidth 64 := by
  bv_decide

/-- `load_3` returns the 3 bytes at `p` as a little-endian number and leaves the state alone. -/
public theorem load_3.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF) (hp : Fits s.mem p 24)
    (hp_off : ¬p.offset.uaddOverflow 3#64) :
    load_3.call (load_3.args (.value p)) s =
      .value (.cons (.value ((s.mem.readAt p 24).setWidth 64)) .nil, s) := by
  func_init
  block_init
  step_pure
  step_load
  step_pure
  step_pure
  step_load
  step_pure
  step_pure
  step_pure
  finish_block
  subst hS
  have hb := load_3.bits (S.mem.readAt p 24)
  rw [MemoryState.readAt_add_of_readAt hp.inBounds
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) (by decide) rfl,
    MemoryState.readAt_of_readAt_le (v := 24) (w := 16) (by decide) rfl]
  simp only [show (2#64).toNat * 8 = 16 from rfl, hb, ite_true]

end Proof

end MLIR.Sodium
