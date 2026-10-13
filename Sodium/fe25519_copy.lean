module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Sodium.Mlir.fe25519_copy

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `fe25519_copy` stores `f`'s limbs at `h`, by a `memcpy`: the two are apart. -/
public theorem fe25519_copy.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) (hsep : h.id ≠ f.id) :
    fe25519_copy.call (fe25519_copy.args (.value h) (.value f)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs h (s.mem.readLimbs f) }) := by
  have hh320 : Room s.mem h 320 := MemoryState.LimbsRoom.room320 hh
  have hf320 : Fits s.mem f 320 := MemoryState.LimbsFit.fits hf
  func_init
  have hf₀ : S₀.mem.LimbsFit f := hS ▸ hf
  block_init
  step_pure
  -- memcpy(h, f, 5 * sizeof h[0]);
  step_memcpy
  finish_block
  rw [hS, MemoryState.storeAt_readAt_eq_storeLimbs hf₀ hh.1]

end Proof

end MLIR.Sodium
