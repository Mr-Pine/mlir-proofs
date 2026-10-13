module

public import MLIR.Run.Tactic
public import Boringssl.Common.Limbs
public import Boringssl.OPENSSL_memmove
public import Boringssl.Mlir.fe_copy_lt

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_copy_lt` stores `f`'s limbs at `h`; the two may overlap. -/
public theorem fe_copy_lt.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) :
    fe_copy_lt.call (fe_copy_lt.args (.value h) (.value f)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs h (s.mem.readLimbs f) }) := by
  have hh320 : Room s.mem h 320 := hh.room320
  have hf320 : Fits s.mem f 320 := hf.fits
  func_init
  have hf₀ : S₀.mem.LimbsFit f := hS ▸ hf
  block_init
  step_pure
  -- OPENSSL_memmove(h, f, sizeof(fe));
  step_call using OPENSSL_memmove.call_eq
  finish_block
  rw [hS, MemoryState.storeAt_eq_storeLimbs hh.1, hf₀.extractLsb'_readAt]

end Proof

end MLIR.Boringssl
