module

public import MLIR.Run.Tactic
public import Boringssl.fe_0
public import Sodium.Mlir.fe25519_0

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `fe25519_0` stores BoringSSL's `fe_0.spec` (zero limbs) at `h`. -/
public theorem fe25519_0.call_eq (h : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) :
    fe25519_0.call (fe25519_0.args (.value h)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs h Boringssl.fe_0.spec }) := by
  have hh320 : Room s.mem h 320 := hh.room320
  func_init
  block_init
  iterate 2 step_pure
  -- memset(&h[0], 0, 5 * sizeof h[0]);
  step_memset
  finish_block
  rw [hS, MemoryState.storeAt_eq_storeLimbs hh.1]
  simp only [BitVec.extractLsb'_zero]
  rfl

end Proof

end MLIR.Sodium
