module

public import MLIR.Run.Tactic
public import Boringssl.fe_1
public import Sodium.Mlir.fe25519_1

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `fe25519_1` stores BoringSSL's `fe_1.spec` (the limbs of `1`) at `h`. -/
public theorem fe25519_1.call_eq (h : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) :
    fe25519_1.call (fe25519_1.args (.value h)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs h Boringssl.fe_1.spec }) := by
  have hh320 : Room s.mem h 320 := hh.room320
  have hov : ¬h.offset.uaddOverflow 8#64 := Pointer.not_uaddOverflow_of_limbs hh.1 (by decide)
  have hh8 : Room s.mem (h.add 8#64) 256 := Room.add_of_le hov (by decide) hh320
  func_init
  block_init
  iterate 3 step_pure
  -- h[0] = 1;
  step_store
  -- memset(&h[1], 0, 4 * sizeof h[0]);
  step_pure
  step_memset
  finish_block
  rw [hS, ← MemoryState.storeAt_append hov (by decide), MemoryState.storeAt_eq_storeLimbs hh.1]
  congr 3

end Proof

end MLIR.Sodium
